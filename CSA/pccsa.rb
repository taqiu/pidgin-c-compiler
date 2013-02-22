#! /usr/bin/ruby
###########################################
#
#  P523
#  Assignment 3: PC context-sence analysis 
#  Author:  Tanghong Qiu
#
###########################################


class PCCSA 
	include RubyWrite

	def initialize
		@my_env = Env.new nil	
	end
	
	def main (node)
		if match? :Program[:type_decls, :fn_defs], node
			lookup(:type_decls).each {|x| traverse_type_decl x}
			p @my_env
			lookup(:fn_defs).each {|x| traverse_fn_defs x}
		end
	end


######################## traverse type declarations begin  #############################################
#
#  traverse type declarations and save identifiers to symble table
#	
#######################################################################################################

	define_rw_rewriter :traverse_type_decl do
		rewrite :TypeDecl[:type_name, :decl_list] do |node|
			@type_name = lookup(:type_name)
			lookup(:decl_list).each {|x| traverse_type_decl x} 
		end
		rewrite :FunctionDecl[:id, :Formals[:params]] do |node|
			@my_env.extend_env lookup(:id), \
				 FuncType.new(@type_name, lookup(:params).map{|x| traverse_formals x})
		end
		rewrite :ArrayRef[:id, :subs] do |node|
			raise "#{node}  can't be void" if @type_name == "void" or @type_name == "void*"		
			dimen = lookup(:subs).length
			@my_env.extend_env lookup(:id), ArrayType.new(@type_name, dimen)
		end 
		rewrite :Pointer[:val] do |node|
			t_name = @type_name
			@type_name = t_name + '*'
			traverse_type_decl(lookup(:val))
			@type_name = t_name
		end
		default do |node|
			raise "\"#{node}\"  can't be void" if @type_name == "void" or @type_name == "void*"		
			@my_env.extend_env node, @type_name
		end
	end

	define_rw_rewriter :traverse_formals do
		rewrite :Formal[:t_name,:id] do |node|
			@formal_type = lookup(:t_name)
			raise "\"#{node}\"  can't be void" if @formal_type == "void" or @formal_type == "void*"		
			traverse_formals lookup(:id)
		end
		rewrite :Pointer[:id] do |node|
			@formal_type += "*"
			traverse_formals lookup(:id)
		end
		rewrite :ArrayArg[:id, :subs] do |node|
			dimen = lookup(:subs).length
			ArrayType.new(@formal_type, dimen)
		end
		default do|node|
			@formal_type
		end
	end

############################ traverse type declarations end  #############################################


############################ traverse function definition begin ##########################################
#
#  traverse functions and check indentifier in symbol table
#
#########################################################################################################

	define_rw_rewriter :traverse_fn_defs do
		rewrite :Function[:rtype, :id, :formals, :block] do |node|
			@function_id = lookup(:id)
			traverse_fn_defs lookup :block
		end
		rewrite :Block[[:type_decls, :stmts]] do |node|
			# Update environment in block
			@my_env = Env.new @my_env
			lookup(:type_decls).each {|x| traverse_type_decl x}
			lookup(:stmts).each {|x|
				begin
					traverse_fn_defs  x
				rescue
					puts "In \"#{@function_id}()\" function: #{$!}" 
				end
			}
			@my_env = @my_env.get_out_env
		end
		rewrite :For[:init, :cond, :after, :body] do |node|
			traverse_fn_defs lookup(:init)
			type_inference lookup(:cond)
			traverse_fn_defs lookup(:after)
			traverse_fn_defs lookup(:body)
		end
		rewrite :While[:cond, :body] do |node|
			type_inference lookup(:cond)
			traverse_fn_defs lookup(:body)
		end
		rewrite :If[:test, :conseq, :alt] do |node|
			type_inference lookup(:test)
			traverse_fn_defs lookup(:conseq)
			traverse_fn_defs lookup(:alt)
		end
		rewrite :Else[:body] do |node|
			traverse_fn_defs lookup(:body)
		end
		rewrite :SimpleStmt[:stmt] do |node|
			traverse_fn_defs lookup(:stmt)
		end
		rewrite :Assignment[:id, :expr] do |node| 
			type_lhs = type_inference lookup(:id)
			type_rhs = type_inference lookup(:expr)
			puts type_lhs
			puts type_rhs
			raise "Can't assign \"#{type_rhs}\" to \"#{lookup :id}\"" if type_lhs != type_rhs
		end
		rewrite :ReturnStmt[:expr] do |node|
			type_inference lookup(:expr)
		end
		default {|node| type_inference node}
	end

############################ traverse function definition end ##########################################


##########################  expression type inference function begin ###################################

	define_rw_rewriter :type_inference do 
		rewrite :ConstInt[:val] do |node|
			"int"
		end 
		rewrite :ConstReal[:val] do |node|
			"double"
		end
		rewrite :ConstString[:val] do |node|
			"char*"
		end
		rewrite :ArrayRef[:id, :subs] do |node|
			dimen_call = lookup(:subs).length
			id = lookup(:id)
			a_type = type_inference id
			raise "#{id} is not an array" unless a_type.kind_of?(ArrayType) 
			type = a_type.type
			dimen_del  = a_type.dimen
			dimen = dimen_del - dimen_call

			if dimen < 0
				raise "\"#{id}\" dimension error"  
			elsif dimen == 0
				type
			else 
				ArrayType.new(type, dimen)
			end
		end
		#######################################################################
		#
		#  Pointer can only be applied to one-dimension array or pointer
		#  e.g.     int *i, j;   j = *i;
		#  	    int a[2][2][2]; 
		#  	    *a[1][1]; // Correct, type is "int"
		#  	    *a[1];    // Wrong
		#
		######################################################################
		rewrite :Pointer[:val] do |node|
			type = type_inference lookup(:val)
			if type.kind_of?(ArrayType) 
				raise "Array \"#{type}\" is not a pointer" if type.dimen != 1
				type.type
			else
				raise "\"#{type}\" is not a pointer " if type[-1,1] != "*"
				type[0..-2]
			end
		end
		######################################################################
		#
		#  Unary operations: &, +, -, !
		#  & can only be applied to basic type ( int, double, char)
		#  ! returns integer 1 or integer 0
		#  + and - can only be applied to int or double
		#
		######################################################################
		rewrite :UnaryOp[:op, :val] do |node|
			puts "unary op"
			op = lookup(:op)
			val = lookup(:val)
			case op 
			when "&"
				type = type_inference val
				if type.kind_of?(ArrayType) 
					raise "Can't get the pointer from array \"#{val}\"" 
				else 
					raise "Can't get the pointer of \"#{val}\"" if type[-1, 1] == "*"
					type+"*"
				end
			when "!"
				"int"
			else
				type = type_inference val
				raise "Can't apply '+' or '-' to \"#{val}\"" if type != "int" or  type != "double"
				type
			end 
		end
		rewrite :Parenthesis[:val] do |node|
			type_inference lookup(:val)
		end
		#####################################################################
		#
		#  Binary operation: ==, <=, >=, +, -, *, /, %
		#  Binary operation can only be applied to double or int
		#  ==, <=, >= returns integer 0 (False) or integer 1 (True) 
		#
		#####################################################################
		rewrite :BinaryOp[:val1, :op, :val2] do |node|
			op = lookup(:op)
			val1 = lookup(:val1)
			val2 = lookup(:val2)
			t_val1 = type_inference val1 
			t_val2 = type_inference val2
			raise "\"#{t_val1}\" must be double or int" unless t_val1 == "double" or t_val1 == "int"
			raise "\"#{t_val2}\" must be double or int" unless t_val2 == "double" or t_val2 == "int"
			case op
				when "==", "<=", ">="
					"int"
				when "+", "-", "/", "*", "%"
					if t_val1 == "double" or t_val2 == "double"
						"double"
					else 
						"int"
					end 
			end
		end
		rewrite :FunctionCall[:id, :params] do |node|
			id = lookup(:id)
			params = lookup(:params)
			type = @my_env.apply_env id
			raise "\"#{id}\" is not a function identifier" unless type.kind_of?(FuncType)
			raise "parameters # don't match" if params.length != type.params.size
			params.size.times {|i|
				puts "---", type_inference(params[i])
				raise "parameters are not match" unless type_inference(params[i]) == type.params[i]
			}
			type.type
		end
		default do |node|
			puts "node??"
			type = @my_env.apply_env node
			raise "\"#{node}\" is a function identifier" if type.kind_of?(FuncType)
			type 
		end	
	end

##########################  expression type inference function begin ###################################

end

################################ Type Classes begin #############################################
#
#     Basic type:  "int", "double", "void", "char"
#   Pointer type:  "int*", "double*", "char*", "void*"
#     Array type:  ArrayType.new(type, dimension)
#  Function type:  FuncType.new(type, param_list)
#
#################################################################################################

class ArrayType
	def initialize(type, dimen)
		@type = type
		@dimen = dimen
	end
	attr_accessor :type, :dimen
end

class FuncType
	def initialize(type, params)
		@type = type
		@params = params	
	end
	attr_accessor :type, :params
end

################################ Type Classes end ## #############################################


################################## Symbol table begin ############################################
#
# A link-list will be used to represent symbol table. Env is the node of link-list
#
#################################################################################################

class Env
	def initialize(env)
		@vals = Hash.new("undefined")
		@out_env = env
	end

	def get_out_env()
		@out_env
	end
	
	def extend_env(name, type)
		raise "Can't re-declare \"#{name}\"" unless  @vals[name] == "undefined" 
		@vals[name] = type
	end

	def apply_env(name)
		if @vals[name] == "undefined"
			if @out_env != nil
				@out_env.apply_env(name)
			else
				raise "Undefined variable \"#{name}\""
			end
		else
			return @vals[name]  
		end
	end
end 

################################## Symbol table end ############################################
