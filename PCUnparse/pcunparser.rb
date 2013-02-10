=begin
  P523 Assignment 2
  Tanghong Qiu
=end 

require 'shadow_boxing'

class PCUnparser
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
			rule :TypeDecl do |typename, decl_list|
				h({}, typename, " ", h_star({}, ", ",*decl_list.children), ";")
			end
			rule :FunctionDecl do |id, formals|
				h({}, id, "(", formals, ")" )
			end
			rule :Function do |rettype, name, args, body|
				v({},
				  h({}, rettype, " ", name,
				  "(", args, ")"),
				 v({:is => 3}, "{", body),
				  "}")
			end
			rule :FunctionCall do |id, params|
				h({}, id, "(",  h_star({}, ", ", *params.children), ")" )
			end

			rule :ConstInt do |val| val end
			rule :ConstReal do |val| val end
			rule :ConstString do |val| val end
			rule :ArrayArg do |id, array_subs| 
				h({}, id,"[",  h_star({},"][", *array_subs.children),"]")
			end
			rule :EmptySubscript do  end
			rule :ArrayRef do |id, indexs| 
				h({}, id, "[", h_star({},"][", *indexs.children), "]")
			end
			rule :Formals do |formals|
				h_star({}, ", ", *formals.children)
			end
	
			rule :Formal do |type_name, id|
				h({:hs => 1},type_name, id)
			end
			rule :RefArg do |id| 
				h({}, "&", id)
			end
			rule :Pointer do |id|
				h({}, "*", id)
			end
			rule :TypePointer do |type|
				h({}, type, "*")
			end
			# Simple statement
			rule :Assignment do |lhs, rhs|
				h({:hs => 1}, lhs, "=", rhs)
			end
			rule :BreakStmt do "break"  end
			rule :ContinueStmt do "continue" end
			rule :ReturnStmt do |val| 
				h({:hs => 1}, "return", val)
			end

			rule :BinaryOp do |rand1, rator, rand2|
				h({:hs => 1}, rand1, rator,  rand2)
			end
			rule :UnaryOp do |op, val|
				h({}, op, val)
			end
			rule :Parenthesis do |exp|
				h({},"(", exp ,")")
			end
	
			rule :Block do |type_dels, stmt_list|
				if type_dels.numChildren == 0 then
					v({}, h_star({}, "",v({}, *stmt_list.children)))
				else 
					v({}, h_star({}, "",v({}, *type_dels.children)), "\n",
					 h_star({}, "",v({},*stmt_list.children)))
				end
			end
			rule :SimpleStmt do |stmt|
				if stmt.respond_to?("value") and stmt.value == :ReturnStmt \
					 and stmt.numChildren == 0 then
					"return;"
				else
					h({}, stmt, ";")
				end
			end
			rule :For do |init, cond, after, body|
				v({}, 
				  h({},"for (",
				     init, "; ", cond, "; ", after, ")" ),
				     v({:is => 3}, "{",
				      body), "}")
			end
			rule :While do |cond, body| 
				v({}, 
				   h({}, "while (",
				      cond, ")"),
				  v({:is => 3}, "{",
				  body), "}")
			end
			rule :If do |test, conseq, alt|
				v({}, 
				  h({}, "if (", test, ")"),
				  v({:is => 3}, "{", 
				 conseq),
				 "}", alt)
			end
			rule :Else do |body| 
				v({}, "else",  v({:is => 3},
				  "{",
				  body),
				"}")
			end
		end

		box = boxer.unparse_node node
		box.to_s
	end
end


