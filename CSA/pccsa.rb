#! /usr/bin/ruby
###########################################
#
#  P523
#  Assignment 3: PC context-sence analysis 
#  Author:  Tanghong Qiu
#
###########################################

$debug = false 

class PCCSA 
	include RubyWrite

	def initialize
		@my_env = Env.new nil	
		@allow_fn_decl = true
		@unparser = PCUnparser.new
		@is_correct = true
	end
	
	def main (node)
		if match? :Program[:type_decls, :fn_defs], node
			lookup(:type_decls).each {|x|
				begin				
					traverse_type_decl x
				rescue
					puts "error: #{$!}"
					@is_correct = false
				end
			}
			puts @my_env if $debug 
			# function declaration is not allowed in blocks
			@allow_fn_decl = false
			lookup(:fn_defs).each {|x| traverse_fn_defs x}
		end
		@is_correct
	end


######################## traverse type declarations begin  #############################################
#
#  traverse type declarations and save identifiers to symble table
#  Variable type (include array) can't be void, but void* is allowed
#	
#######################################################################################################

	define_rw_rewriter :traverse_type_decl do
		rewrite :TypeDecl[:type_name, :decl_list] do |node|
			@type_name = lookup(:type_name)
			lookup(:decl_list).each {|x| traverse_type_decl x} 
		end
		rewrite :FunctionDecl[:id, :Formals[:params]] do |node|
			raise "Can't declare \'#{lookup(:id)}\' inside a function" unless @allow_fn_decl 
			@my_env.extend_env lookup(:id), \
				 FuncType.new(@type_name, lookup(:params).map{|x| traverse_formals x})
		end
		rewrite :ArrayRef[:id, :subs] do |node|
			raise "declaration of \'#{lookup(:id)}\' as array of voids  " if @type_name == "void"
			subs = lookup(:subs)
			subs.each {|x|
				raise "size of array \'#{lookup(:id)}\' has non-integer type" if type_inference(x) != 'int'
			}
			dimen = subs.length
			@my_env.extend_env lookup(:id), ArrayType.new(@type_name, dimen)
		end 
		rewrite :Pointer[:val] do |node|
			t_name = @type_name
			@type_name = t_name + '*'
			traverse_type_decl(lookup(:val))
			@type_name = t_name
		end
		default do |node|
			raise "storage size of \'#{node}\' is unkown" if @type_name == "void"		
			@my_env.extend_env node, @type_name
		end
	end
	# traverse formal parameters of functions, return type
	define_rw_rewriter :traverse_formals do
		rewrite :Formal[:t_name,:id] do |node|
			@formal_type = lookup(:t_name)
			raise "parameter \'#{display_node node}\' has void type" if @formal_type == "void"
			if lookup(:id) == []
				@formal_type
			else
				traverse_formals lookup(:id)
			end
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
		rewrite :Function[:rtype, :id, :Formals[:formals], :block] do |node|
			# update environment in block
			@my_env = Env.new @my_env
			@function_id = lookup(:id)
			rtype = traverse_fn_defs lookup(:rtype)
			begin
				if @function_id != "main"
					type = @my_env.apply_env @function_id
					rtype_decl = type.type	
					params_decl = type.params	
					params_def = lookup(:formals).map {|x| traverse_formals x}
					raise "conflicting types for \'#{@function_id}\'" if params_decl != params_def \
						or rtype != rtype_decl
				end
			rescue
				puts "error: #{$!}"
				@is_correct = false
			end

			lookup(:formals).each { |x| extend_params x}
			traverse_fn_defs lookup(:block)
			# recover environment	
			@my_env = @my_env.get_out_env
		end
		rewrite :Block[[:type_decls, :stmts]] do |node|
			lookup(:type_decls).each {|x|
				begin
					traverse_type_decl x
				rescue
					puts "In function \'#{@function_id}\': error: #{$!}" 
					@is_correct = false
				end
			}
			puts @my_env if $debug
			lookup(:stmts).each {|x|
				begin
					traverse_stmts  x
				rescue
					puts "In function \'#{@function_id}\': error: #{$!}" 
					@is_correct = false
				end
			}
		end
		rewrite :TypePointer[:type] do |node|
			lookup(:type) + "*"
		end
		default { |node| node}
	end

	define_rw_rewriter :extend_params do
		rewrite :Formal[:type,:id] do |node|
			@formal_type = lookup(:type)
			raise "\"#{node}\"  can't be void" if @formal_type == "void"
			raise "parameter name omitted" if lookup(:id) == []
			extend_params lookup(:id)
		end
		rewrite :Pointer[:id] do |node|
			@formal_type += "*"
			extend_params lookup(:id)
		end
		rewrite :ArrayArg[:id, :subs] do |node|
			dimen = lookup(:subs).length
			@my_env.extend_env lookup(:id), ArrayType.new(@formal_type, dimen)
		end
		default do|node|
			@my_env.extend_env node, @formal_type
		end
	end
	
	define_rw_rewriter :traverse_stmts do
		rewrite :Block[[:type_decls, :stmts]] do |node|
			# update environment in block
			@my_env = Env.new @my_env
			lookup(:type_decls).each {|x|
				begin
					traverse_type_decl x
				rescue
					puts "In function \'#{@function_id}\': error: #{$!}" 
					@is_correct = false
				end
			}
			puts @my_env if $debug
			lookup(:stmts).each {|x|
				begin
					traverse_stmts  x
				rescue
					puts "In function \'#{@function_id}\': error: #{$!}" 
					@is_correct = false
				end
			}
			# recover environment	
			@my_env = @my_env.get_out_env
		end
		rewrite :For[:init, :cond, :after, :body] do |node|
			traverse_stmts lookup(:init)
			traverse_stmts lookup(:cond)
			traverse_stmts lookup(:after)
			traverse_stmts lookup(:body)
		end
		rewrite :While[:cond, :body] do |node|
			traverse_stmts lookup(:cond)
			traverse_stmts lookup(:body)
		end
		rewrite :If[:test, :conseq, :alt] do |node|
			traverse_stmts lookup(:test)
			traverse_stmts lookup(:conseq)
			if lookup(:alt) != []
				traverse_stmts lookup(:alt)
			end
		end
		rewrite :Else[:body] do |node|
			traverse_stmts lookup(:body)
		end
		rewrite :SimpleStmt[:stmt] do |node|
			traverse_stmts lookup(:stmt)
		end
		##################################################################
		#
		#  The type of assigmnment both sides should be same.
		#  ArrayType(type , 1) can be assigned to type*, but type* is not
		#  allowed to be assigned to ArrayType(type, 1) 
		#
		#################################################################
		rewrite :Assignment[:id, :expr] do |node| 
			type_lhs = traverse_stmts lookup(:id)
			type_rhs = traverse_stmts lookup(:expr)
			raise "Can't assign \'#{type_rhs}\' to \'#{display_node lookup :id}\'"  unless assignment? type_lhs, type_rhs
		end
		rewrite :ReturnStmt[:expr] do |node|
			traverse_stmts lookup(:expr)
		end
		rewrite :ReturnStmt[] do |node|
			#do nothing
		end
		rewrite :ContinueStmt[] do |node|
			#do nothing
		end
		rewrite :BreakStmt[] do |node|
			#do nothing
		end
		default {|node| type_inference node}
	end

	# compare two variable, check whether right hand side value can be assgined left hand side 
	def assignment? (type_lhs, type_rhs)
			puts "Assignment: #{type_rhs} -> #{type_lhs}" if $debug
			if type_lhs == type_rhs
				true
			elsif type_rhs.kind_of?(ArrayType) and type_rhs.dimen == 1 \
				and (not type_lhs.kind_of?(ArrayType)) and type_lhs == type_rhs.type + "*"
				true
			elsif type_lhs == 'double' and type_rhs == 'int'
				true
			else
				false
			end
	end

	# display the identifier or value of the given node
	def display_node (node)
		@unparser.unparse node
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
			subs = lookup(:subs)
			subs.each {|x|
				raise "array subscript is not a integer" if type_inference(x) != 'int'
			}
			dimen_call = subs.length
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
				raise "Array \'#{type}\' is not a pointer" if type.dimen != 1
				type.type
			else
				raise "\'#{type}\' is not a pointer " if type[-1,1] != "*"
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
			op = lookup(:op)
			val = lookup(:val)
			case op 
			when "&"
				type = type_inference val
				if type.kind_of?(ArrayType) 
					raise "Can't get the pointer from array \'#{display_node val}\'" 
				else 
					raise "Can't get the pointer of \'#{display_node val}\'"  if type[-1, 1] == "*"
					type+"*"
				end
			when "!"
				"int"
			else
				type = type_inference val
				raise "Can't apply '+' or '-' to \'#{val}\'" if type != "int" and  type != "double"
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
		#  Casting rule:  int -> double (force casting is unavalibable)
		#
		#####################################################################
		rewrite :BinaryOp[:val1, :op, :val2] do |node|
			op = lookup(:op)
			val1 = lookup(:val1)
			val2 = lookup(:val2)
			t_val1 = type_inference val1 
			t_val2 = type_inference val2
			raise "\"#{display_node val1}\" must be double or int" unless t_val1 == "double" or t_val1 == "int"
			raise "\"#{despaly_node val2}\" must be double or int" unless t_val2 == "double" or t_val2 == "int"
			case op
				when "==", "<=", ">=", "<", ">"
					"int"
				when "+", "-", "/", "*"
					if t_val1 == "double" or t_val2 == "double"
						"double"
					else 
						"int"
					end 
				when "%"
					raise "invalid operands to binary %" unless t_val1 == "int" and t_val2 == "int"
					"int"
				else
					raise "unkown binary operation \'#{op}\'"
			end
		end
		rewrite :FunctionCall[:id, :params] do |node|
			id = lookup(:id)
			params = lookup(:params)
			type = @my_env.apply_env id
			raise "called object \"#{id}\" is not a function" unless type.kind_of?(FuncType)
			raise "parameters # don't match" if params.length != type.params.size
			params.size.times {|i|
				raise "\'#{id}\' parameters are not matched" unless assignment? type.params[i], type_inference(params[i])
			}
			type.type
		end
		default do |node|
			type = @my_env.apply_env node
			raise "\"#{node}\" is a function identifier" if type.kind_of?(FuncType)
			type 
		end	
	end

##########################  expression type inference function end ###################################
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
	
	def ==(object)
		if object.kind_of?(ArrayType)
			if object.type == @type and @dimen == object.dimen 
				true
			else
				false
			end
		else
			false
		end
	end

	def to_s
		"[Array: #{@type} - #{@dimen}]"
	end

	attr_accessor :type, :dimen
end

class FuncType
	def initialize(type, params)
		@type = type
		@params = params	
	end

	def to_s
		"[Func: #{@type} - {#{@params.join ", "}}]"
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
		if defined? @@scope_id 
			@@scope_id += 1
		else
			@@scope_id = 0
		end
		@id = @@scope_id
		puts  "+--------------- begin of scope #{@@scope_id} ---------------------+\n" if $debug
	end

	def get_out_env()
		puts "+---------------- end of scope #{@@scope_id} ----------------------+ \n " if $debug
		@@scope_id -= 1
		@out_env
	end
	
	def extend_env(name, type)
		raise "previous declaration of \'#{name}\' was here " unless  @vals[name] == "undefined" 
		@vals[name] = type
	end

	def apply_env(name)
		if @vals[name] == "undefined"
			if @out_env != nil
				@out_env.apply_env(name)
			else
				raise "\'#{name}\' undeclared" 
			end
		else
			puts "Apply scope #{@id}: #{name} => #{@vals[name]}" if $debug 
			@vals[name]  
		end
	end
	
	def to_s
		output = "+----------------- symbol table #{@@scope_id} ---------------------+\n"
		@vals.each {|key,value| output += "| %4s => %s \n" % [key, value]}
		output += "+------------------------------------------------------+\n"	
		output
	end
end 

################################## Symbol table end ############################################
