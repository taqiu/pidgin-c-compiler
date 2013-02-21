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
			lookup(:fn_defs).each {|x| traverse_fn_defs x}
		end
		p @my_env
	end


######################## traverse type declarations begin  #############################################	
	define_rw_rewriter :traverse_type_decl do
		rewrite :TypeDecl[:type_name, :decl_list] do |node|
			@type_name = lookup(:type_name)
			lookup(:decl_list).each {|x| traverse_type_decl x} 
			#puts "type decl"
		end
		rewrite :FunctionDecl[:id, :Formals[:params]] do |node|
			@my_env.extend_env lookup(:id), FuncType.new(@type_name, lookup(:params).map{|x| traverse_formals x})
			#puts "fun params"
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
	
	define_rw_rewriter :traverse_fn_defs do
		rewrite :Function[:rtype, :id, :formals, :block] do |node|
			#puts "function #{lookup :id}"
			traverse_fn_defs lookup :block
		end
		rewrite :Block[[:type_decls, :stmts]] do |node|
			@my_env = Env.new @my_env
			lookup(:type_decls).each {|x| traverse_type_decl x}
			lookup(:stmts).each {|x| traverse_stmt  x}
			@my_env = @my_env.get_out_env
		end
		default {|node| node}	
	end
	
	define_rw_rewriter :traverse_stmt  do
		rewrite :SimpleStmt[:stmt] do |node|
			traverse_stmt lookup(:stmt)
		end
		rewrite :Assignment[:id, :expr] do |node| 
			type_lhs = @my_env.apply_env lookup(:id)
			type_rhs = type_inference lookup(:expr)
			puts type_lhs
			puts type_rhs
			raise "Can't assign \"#{type_rhs}\" to \"#{lookup :id}\"" if type_lhs != type_rhs
		end
		default {|node| node}
	end

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
			type, dimen_del  = type_inference id			
			dimen = dimen_del - dimen_call
			if dimen < 0
				raise "\"#{id}\" dimension error"  
			elsif dimen == 0
				type
			elsif dimen == 1 and type[-1,1] != "*" 
				type+"*" 
			else 
				[type, dimen]
			end
		end
		rewrite :Pointer[:val] do |node|
			type = type_inference lookup(:val)
			if type.size == 2 
				if type[1] == 1
					type[0]
				else
					[type[0], type[1]-1]
				end
			else
				raise "\"#{type}\" is not a pointer " if type[-1,1] != "*"
				type[0..-2]
			end
		end
		rewrite :UnaryOp[:op, :val] do |node|
			puts "unary op"
			op = lookup(:op)
			val = lookup(:val)
			if op == "&"
				type = type_inference val
				if type.size == 2 
					raise "Can't get the pointer from array \"#{val}\"" 
				else
					raise "Can't get the pointer of \"#{val}\"" if type[-1, 1] == "*"
					type+"*"
				end
			else
				type_inference val
			end 
		end
		rewrite :Parenthesis[:val] do |node|
			type_inference lookup(:val)
		end
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
				when "+", "-", "/", "*"
					if t_val1 == "double" or t_val2 == "double"
						"double"
					else 
						"int"
					end 
			end
		end
		rewrite :FuntionCall[:id, :params] do |node|
			id = lookup(:id)
			params = lookup(:params)
			type = @my_env.apply_env id
			if type.size != 2 or type[1].kind_of?(Integer)
				raise "\"#{id}\" is not a function identifier"
			end
			raise "parameters # don't match" if params.length != type[1].size
			params.length.each {|i| 
				if type_inference(params[i]) != type[1][i] 
					raise "parameters are not match"
				end 
			}
			type[0]
		end
		default do |node|
			puts "node??"
			type = @my_env.apply_env node
			if type.size == 2 and not type[1].kind_of?(Integer)
				raise "\"#{node}\" is a function identifier"
			end	
			type 
		end	
	end
end

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


class Env
	def initialize(env)
		@vals = Hash.new("undefined")
		@out_env = env
	end

	def get_out_env()
		@out_env
	end
	
	def extend_env(name, type)
		raise "Can't re-declare #{name}" unless  @vals[name] == "undefined" 
		@vals[name] = type
	end

	def apply_env(name)
		if @vals[name] == "undefined"
			if @out_env != nil
				@out_env.apply_env(name)
			else
				raise "Undefined variable #{name}"
			end
		else
			return @vals[name]  
		end
	end
end 


