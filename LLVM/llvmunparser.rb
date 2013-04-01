#! /usr/bin/ruby

##########################################
#
#  P523
#  Assignment 5: an initial translator from 
#           PidginC to LLVM assembly language 
#  Author:  Tanghong Qiu
#
###########################################


require 'shadow_boxing'

class LLVMUnparser
	def unparse(node)
		boxer = ShadowBoxing.new do
			rule :Program do |decls, funs|
				if decls.numChildren == 0 then
					v({}, h_star({}, "\n\n",  *funs.children))
				else
					v({}, h_star({}, "\n",  *decls.children),"\n" ,
					h_star({}, "\n\n",  *funs.children))
				end
			end
			rule :GlobalVar do |var, type|
				if type.respond_to?("value") and type.value == :ArrayRef
					h({}, var, " = common global ", type, " zeroinitializer")
				elsif type[-1,1] == "*"
					h({}, var, " = common global ", type, " null")
				elsif type == "double"
					h({}, var, " = common global ", type, " 0.000000e+00")
				else
					h({}, var, " = common global ", type, " 0")
				end
			end
			rule :ArrayRef do |val|
				val
			end
			rule :Function do |rettype, name, args, body|
				v({},
				  v({:is => 3},
				  h({}, "define ", rettype, " ", name,
				  "(", h_star({}, ", ", *args.children), ") {"),
				   h_star({}, "", v({}, *body.children))),
				  "}")
			end
			rule :Formal do |type, id|
				h({}, type, " ", id)
			end
			rule :Alloca do |id, type|
				h({}, id, " = alloca ", type)			
			end
			rule :Store do |type, id, type_ptr, addr|
				h({}, "store ", type, " ", id, ", ", type_ptr, " ", addr)
			end
			rule :Load do |id, type, addr|
				h({}, id, " = load ", type, " ", addr)
			end
			rule :Return do |type, val| 
				h({}, "ret ", type, " ", val)
			end
			rule :GEP do |id, type, addr, subs|
				h({}, id, " = getelementptr ", type, " ", addr, ", ", subs.join(", "))
			end
			rule :BinaryOp do |id, op, type, var1, var2|
				h({}, id, " = ", op, " ", type, " ", var1, ", ", var2)
			end
			rule :Call do |var, type, id, params| 
				h({}, var, " = call ", type, " ", id, "(", params.join(", "),")" )
			end
			rule :VoidCall do |id, params|
				h({}, "call void ", id, "(", params.join(", "), ")")
			end
			rule :Conv do |id, expr|
				h({}, id, " = ", expr)
			end
		end

		box = boxer.unparse_node node
		box.to_s
	end
end
