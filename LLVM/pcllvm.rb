#! /usr/bin/ruby

##########################################
#
#  P523
#  Assignment 5: an initial translator from 
#           PidginC to LLVM assembly language 
#  Author:  Tanghong Qiu
#
###########################################
#
#  Last modify: 04/02/2013
#  
#  Unfinished work:
#  - assignment type casting 
#  - function call type casting 
#  - char and string is not supported yet because of the inherent problem in the scanner
#    the compile can't output exetutable llvm assemblly with char or string
#  - compound statements
#  - camparsion statements
#


class PCLLVM
	include RubyWrite
	
	def initialize
		@lenv = LEnv.new nil
	end

	def main (node)
		if match? :Program[:type_decls, :fn_defs], node
			global_vars = []
			lookup(:type_decls).each {|x|
				global_vars += trav_global_vars x
			}
			functions = []
			lookup(:fn_defs).each{|x|
				functions += [trav_functions x]
			}
			build :Program[global_vars, functions]
		end
	end

	define_rw_rewriter :trav_global_vars do
		rewrite :TypeDecl[:type_name, :decl_list] do |node|
			type_name = lookup(:type_name)
			if type_name == "int"
				@type_name = "i32"
			elsif type_name == "double"
				@type_name = "double"
			elsif type_name == "void"
				@type_name = "void"
			else
				@type_name = "i8"
			end
			global_vars = []
			lookup(:decl_list).each{|x|
				ret = trav_global_vars x
				global_vars += [ret] if ret != nil 
			}
			global_vars	
		end
		rewrite :FunctionDecl[:id, :Formals[:params]] do |node|
			@lenv.extend_env lookup(:id), [@type_name, lookup(:params).map{|x| trav_formals x}]	
			# return nothing for function declaration
			nil	
		end
		rewrite :ArrayRef[:id, :sub] do |node|
			subs = lookup(:sub).map{|x| trav_global_vars x}
			@lenv.extend_env lookup(:id), [@type_name, subs]
			array_type = to_array_type [@type_name, subs] 
			build :GlobalVar["@"+lookup(:id), :ArrayRef[array_type]]
		end
		rewrite :ConstInt[:val] do |node|
			lookup(:val)
		end
		rewrite :Pointer[:val] do |node|
			t_name = @type_name
			@type_name = t_name + '*'
			val = trav_global_vars lookup(:val)
			@type_name = t_name
			val
		end
		default do |node|
			@lenv.extend_env node, @type_name
			build :GlobalVar["@"+node , @type_name]
		end
	end

	def to_array_type (type)
		array_type = type[0]
		subs = type[1] 
		subs.reverse.each { |x|
			array_type = "[" + x + " x "  +  array_type + "]"
		}
		array_type
	end

	def to_array_ptr (type)
		array_ptr = type[0]
		subs = type[1]
		if subs.length == 1
			array_ptr+"*"
		else
			subs = subs[1..-1]
			subs.reverse.each { |x|
				array_ptr = "[" + x + " x "  +  array_ptr + "]"
			}
			array_ptr+"*"
		end
	end

	def to_llvm_type (type_name)
		if type_name == "int"
                	"i32"
                elsif type_name == "double"
                        "double"
                else
                        "i8"
                end
	end
	
	define_rw_rewriter :trav_formals do
		rewrite :Formal[:t_name, :id] do |node|
			type_name = lookup(:t_name)
			if type_name == "int"
                                @formal_type = "i32"
                        elsif type_name == "double"
                                @formal_type = "double"
                        else
                                @formal_type = "i8"
                        end
			if lookup(:id) == []
				@formal_type
			else 
				trav_formals lookup(:id)
			end
		end
		rewrite :Pointer[:id] do |node|
			@formal_type += "*"
			trav_formals lookup(:id)
		end
		rewrite :ArrayArg[:id, :subs] do |node|
			subs = lookup(:subs).map{|x| trav_formals x}
			[@formal_type, subs]	
                end
                rewrite :ConstInt[:val] do |node|
                        lookup(:val)
                end
		default do|node|
			@formal_type
		end
	end

	define_rw_rewriter :trav_functions do
		rewrite :Function[:rtype, :id, :Formals[:formals], :block] do
			@temp_count = 1 
			@lenv = LEnv.new @lenv
			type_name = lookup(:rtype)
                        if type_name == "int"
                                rtype = "i32"
                        elsif type_name == "double"
                                rtype = "double"
                        elsif type_name == "void"
				rtype = "void"
			else
                                rtype = "i8"
                        end
			
			formals = lookup(:formals).map {|x| extend_params x}		
			block = trav_functions lookup(:block)
			# recover environment
			@lenv = @lenv.get_out_env
			build :Function[rtype, "@"+lookup(:id), formals, block ]
		end 
		rewrite :Block[[:type_decls, :stmts]] do |node|
			stmts = []
			# Add formal parameter declarations
			@lenv.get_all.each { |key, value|
				if value.kind_of?(Array)
					type = to_array_ptr(value)
				else
					type = value
				end
				stmts += [build :Alloca["%"+key+".addr", type]]
				stmts += [build :Store[type, "%"+key, type+"*", "%"+key+".addr"]]
			}
			@lenv = LEnv.new @lenv	
			lookup(:type_decls).each {|x| stmts += trav_local_decl x }
			lookup(:stmts).each {|x| stmts += trav_stmts x}
			# recover environment
			@lenv = @lenv.get_out_env
			stmts
		end
	end
	
	define_rw_rewriter :trav_local_decl do
		rewrite :TypeDecl[:type_name, :decl_list] do |node|
			type_name = lookup(:type_name)
			if type_name == "int"
				@type_name = "i32"
			elsif type_name == "double"
				@type_name = "double"
			else
				@type_name = "i8"
			end
			local_decls = []
			lookup(:decl_list).each{|x|
				ret = trav_local_decl x
				local_decls += [ret]  
			}
			local_decls	
		end
		rewrite :ArrayRef[:id, :sub] do |node|
			subs = lookup(:sub).map{|x| trav_local_decl x}
			@lenv.extend_env lookup(:id), [@type_name, subs]
			array_type = to_array_type [@type_name, subs] 
			build :Alloca["%"+lookup(:id), array_type]
		end
		rewrite :ConstInt[:val] do |node|
			lookup(:val)
		end
		rewrite :Pointer[:val] do |node|
			t_name = @type_name
			@type_name = t_name + '*'
			val = trav_local_decl lookup(:val)
			@type_name = t_name
			val
		end
		default do |node|
			@lenv.extend_env node, @type_name
			build :Alloca["%"+node, @type_name]
		end
	end

	define_rw_rewriter :extend_params do
		rewrite :Formal[:type,:id] do |node|
			@formal_type = to_llvm_type(lookup(:type))
			extend_params lookup(:id)
		end
		rewrite :Pointer[:id] do |node|
			@formal_type += "*"
			extend_params lookup(:id)
		end
		rewrite :ArrayArg[:id, :subs] do |node|
			type = [@formal_type, lookup(:subs).map{|x| extend_params x}]
			@lenv.extend_env lookup(:id), type
			build :Formal[to_array_ptr(type), "%" + lookup(:id)]
		end
		rewrite :ConstInt[:val] do |node|
                        lookup(:val)
                end
		default do |node|
			@lenv.extend_env node, @formal_type
			build :Formal[@formal_type, "%" + node]
		end
	end

	define_rw_rewriter :trav_stmts do
		rewrite :SimpleStmt[:stmt] do |node|
			@expr_stmts = []
			trav_stmts lookup(:stmt)
		end
		rewrite :Assignment[:id, :expr] do |node|
			stmts = []
			varr, typer = trav_expr lookup(:expr)
			varl, typel = trav_assign_lhs lookup(:id)
			stmts +=  @expr_stmts
			stmts += [build :Store[typel, varr, typel+"*", varl]]
			stmts
		end
		rewrite :ReturnStmt[:expr] do |node|
			var, type = trav_expr lookup(:expr)
			@expr_stmts += [build :Return[type, var]]
			@expr_stmts	
		end
		default do |node|
			trav_expr node
			@expr_stmts
		end
	end

	define_rw_rewriter :trav_assign_lhs do 
		rewrite :ArrayRef[:id, :subs] do |node|
			val, type = trav_expr lookup(:id)
	
			if val[0,1] == "@"
				var = get_temp_var
				atype = to_array_type type
				subs = lookup(:subs).map{|x|
					idx, idx_type = trav_expr x
					"i32 "+ idx
				}
				@expr_stmts += [build :GEP[var, atype+"*", val, ["i32 0"] + subs]]
				[var, type[0]]
			elsif val[-5, 5] == ".addr"
				var = get_temp_var 
				atype = to_array_ptr type
				@expr_stmts += [build :Load[var, atype+"*", val]]
				count = 0
				var1 = ""
				last_var = ""
				lookup(:subs).each { |x|
					var1 = get_temp_var
					idx, idx_type = trav_expr x
					if count == 0
						atype = to_array_ptr type
						@expr_stmts += [build :GEP[var1, atype, var, ["i32 "+idx]]]	
					else
						atype = to_array_type [type[0], type[1][count..-1]]
						@expr_stmts += [build :GEP[var1, atype+"*", last_var, ["i32 0", "i32 "+idx]]]
					end
					last_var = var1
					count += 1
				}
				[var1, type[0]]
			else
				count = 0
				var = ""
				lookup(:subs).each { |x|
					idx, idx_type = trav_expr x
					atype = to_array_type [type[0], type[1][count..-1]]
					if count == 0
						last_var = val 
					else
						last_var = var
					end
					var = get_temp_var
					@expr_stmts += [build :GEP[var, atype+"*",  last_var ,["i32 0","i32 "+idx]]]
					count += 1
				}
				[var, type[0]]
			end
		end
		rewrite :Pointer[:val] do |node|
			val, type = trav_assign_lhs lookup(:val)
			var = get_temp_var
			@expr_stmts += [build :Load[var, type+"*", val]]
			[var, type[0..-2]]
		end
		default do |node|
			type, layer = @lenv.apply_env node
			if layer == 0
				var = "@"+node
			elsif layer == 1
				var = "%"+node+".addr"
			else
				var = "%"+node
			end
			[var, type]		
		end
	end

	define_rw_rewriter :trav_expr do
		rewrite :ConstInt[:val] do |node|
			[lookup(:val), "i32"]
		end
		rewrite :ConstReal[:val] do |node|
			[lookup(:val), "double"]
		end
		rewrite :ArrayRef[:id, :subs] do |node|
			val, type = trav_expr lookup(:id)
	
			if val[0,1] == "@"
				var = get_temp_var
				atype = to_array_type type
				subs = lookup(:subs).map{|x|
					idx, idx_type = trav_expr x
					"i32 "+ idx
				}
				@expr_stmts += [build :GEP[var, atype+"*", val, ["i32 0"] + subs]]
				var1 = get_temp_var
				@expr_stmts += [build :Load[var1, type[0]+"*", var]]
				[var1, type[0]]
			elsif val[-5, 5] == ".addr"
				var = get_temp_var 
				atype = to_array_ptr type
				@expr_stmts += [build :Load[var, atype+"*", val]]
				count = 0
				var1 = ""
				last_var = ""
				lookup(:subs).each { |x|
					var1 = get_temp_var
					idx, idx_type = trav_expr x
					if count == 0
						atype = to_array_ptr type
						@expr_stmts += [build :GEP[var1, atype, var, ["i32 "+idx]]]	
					else
						atype = to_array_type [type[0], type[1][count..-1]]
						@expr_stmts += [build :GEP[var1, atype+"*", last_var, ["i32 0", "i32 "+idx]]]
					end
					last_var = var1
					count += 1
				}

				var2 = get_temp_var
				@expr_stmts += [build :Load[var2, type[0]+"*", var1]]
				[var2, type[0]]
			else
				count = 0
				var = ""
				lookup(:subs).each { |x|
					idx, idx_type = trav_expr x
					atype = to_array_type [type[0], type[1][count..-1]]
					if count == 0
						last_var = val 
					else
						last_var = var
					end
					var = get_temp_var
					@expr_stmts += [build :GEP[var, atype+"*",  last_var ,["i32 0","i32 "+idx]]]
					count += 1
				}
				var1 = get_temp_var
				@expr_stmts += [build :Load[var1, type[0]+"*", var]]
				[var1, type[0]]
			end
		end
		rewrite :Pointer[:val] do |node|
			val, type = trav_expr lookup(:val)
			var = get_temp_var
			@expr_stmts += [build :Load[var, type, val]]
			[var, type[0..-2]]
		end
		rewrite :UnaryOp[:op, :val] do |node|
			op = lookup(:op)
			val = lookup(:val)
			case op
			when "&"
				type, layer = @lenv.apply_env val
				if layer == 0
					["@"+val, type+"*"]	
				elsif layer == 1
					["%"+val+".addr", type+"*"]
				else 
					["%"+val, type+"*"]
				end
			when "-"
				trav_expr build :BinaryOp[:ConstInt["0"], "-", val]
			when "+"
				trav_expr val
			end
		end
		rewrite :Parenthesis[:val] do |node|
			trav_expr lookup(:val)
		end
		rewrite :BinaryOp[:val1, :op, :val2] do |node|
			val1, type1 = trav_expr lookup(:val1)
			val2, type2 = trav_expr lookup(:val2)
			op = lookup(:op)
			var = get_temp_var
			if type1 == "i32" and type2 == "i32" 
				if op == "+"
					lop = "add"
				elsif op == "-"
					lop = "sub"
				elsif op == "/"
					lop = "sdiv"
				elsif op == "*"
					lop = "mul"
				end
				type = "i32"
			else
				if type1 == "i32"
					conv1 = get_temp_var
					@expr_stmts += [build :Conv[conv1, "sitofp i32 "+ val1  + " to double"]]			
					val1 = conv1
				end 
	
				if type2 == "i32"
					conv2 = get_temp_var
					@expr_stmts += [build :Conv[conv2, "sitofp i32 "+ val2  + " to double"]]			
					val2 = conv2
				end

				if op == "+"
                                        lop = "fadd"
                                elsif op == "-"
                                        lop = "fsub"
                                elsif op == "/"
                                        lop = "fdiv"
                                elsif op == "*"
                                        lop = "fmul"
                                end
				type = "double"
			end
			@expr_stmts += [build :BinaryOp[var, lop, type, val1, val2]]
			[var, type]
		end
		rewrite :FunctionCall[:id, :params] do |node|
			id = lookup(:id)
			params = lookup(:params).map { |x|
				var, type = trav_expr x
				if type.kind_of?(Array)
					var1 = get_temp_var
					@expr_stmts += [build :GEP[var1, to_array_type(type)+"*" , var, ["i32 0", "i32 0"]]]
					to_array_ptr(type) + " " + var1
				else
					type + " " + var
				end
			}
			rtype, layer = @lenv.apply_env id
			if rtype[0] == "void"
				@expr_stmts += [build :VoidCall["@"+id, params]]
				[]
			else
				var = get_temp_var
				@expr_stmts += [build :Call[var, rtype[0],"@"+id, params]]
				[var, rtype]
			end
		end
		default do |node|
			type, layer = @lenv.apply_env node
	
			if layer == 0
				if not type.kind_of?(Array)
					var = get_temp_var
					@expr_stmts += [build :Load[var, type+"*", "@"+node]]
				else
					var = "@"+node
				end
			elsif layer == 1
				if not type.kind_of?(Array) 
					var = get_temp_var
					@expr_stmts += [build :Load[var, type+"*", "%"+node+".addr"]]
				else
					var = "%"+node+".addr"
				end
			else
				if not type.kind_of?(Array)
					var = get_temp_var
					@expr_stmts += [build :Load[var, type+"*", "%"+node]]
				else
					var = "%"+node
				end 
			end
		
			[var, type]		
		end
	end

	def get_temp_var () 
		var = "%temp" + @temp_count.to_s
		@temp_count += 1
		var
	end
end 

class LEnv
	def initialize(env)
		@vals = Hash.new("undefined")
		@out_env = env
		if defined? @@scope_id
			@@scope_id += 1
		else
			@@scope_id = 0
		end	
		@id = @@scope_id
	end

	def get_out_env()
		@@scope_id -= 1
		@out_env
	end

	def extend_env(name, type)
		@vals[name] = type
	end
		
	def apply_env(name)
		if @vals[name] == "undefined"
			if @out_env != nil
				@out_env.apply_env(name)
			end
		else
			[@vals[name], @id]
		end
	end

	def get_all()
		@vals
	end

	def to_s
		output = "+----------------- symbol table #{@@scope_id} ---------------------+\n"
		@vals.each {|key,value| output += "| %4s => %s \n" % [key, value]}
		output += "+------------------------------------------------------+\n"	
		output
	end
end

