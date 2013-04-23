#! /usr/bin/ruby
###########################################
#
#  P523
#  Project: Auto-parallelization of PidginC
#  
#  Author: Tanghong Qiu (taqiu@indiana.edu)
#          Zi Wang      (wang417@indiana.edu)
#
###########################################


class AutoParallel
	include RubyWrite

	def main (node)
		if match? :Program[:type_decls, :fn_defs], node
			build :Program[:type_decls, lookup(:fn_defs).map {|x| trav_fns x}]
		end
	end

	define_rw_rewriter :trav_fns do
		rewrite :Function[:rtype, :id, :formals, :block] do |node|
			build :Function[:rtype, :id, :formals, trav_fns(lookup(:block))]
		end
		rewrite :Block[[:type_decls, :stmts]] do |node|
			build :Block[[:type_decls, lookup(:stmts).map {|x| find_for_loop x}]]
		end
	end


	######### find the for loop node #######################
	define_rw_rewriter :find_for_loop do 
		rewrite :For[:init, :cond, :after, :body] do |node|
			# to-do
			@stmt_count = 1
			den_ast = for_loop_rewriter node						
			#puts den_ast
			dependence_graph = gen_dependence_graph(den_ast, [])
			
			@dependence_counter = Hash.new(0)
			dependence_graph.each { |x| 
				@dependence_counter[x.level] += 1
				#puts x
			}
			#puts "-------------------------------------"
			@level = 0
			add_openMP node
		end
		default {|node| node}
	end

	define_rw_rewriter :add_openMP do
		rewrite :For[:init, :cond, :after, :Block[[:type_decls, :stmts]]] do |node|
			@level += 1
			#puts "level: #{@level} - #{@dependence_counter[@level]}"
			re = nil
			if @dependence_counter[@level] == 0
				build :OpenmpFor[node]
			else
				rstmts = []
				stmts = lookup(:stmts)
				stmts.each { |x| rstmts += [add_openMP x]}
				build :For[:init, :cond, :after, :Block[[:type_decls, rstmts]]]
			end
		end
		default {|node| node}
	end

	def gen_dependence_graph(den_tree, index_list)
		index_list += [den_tree.index]
		dependence_graph = []
		den_tree.stmts.each { |x|
			if x.kind_of?(ForLoop) 
				dependence_graph += gen_dependence_graph(x, index_list)
			else
				stmts = stmts_list(den_tree, x)
				stmts.each { |s|
					dependence_graph += dependence(x, s, index_list)
				}
			end
		}

		dependence_graph
	end


	def stmts_list(den_tree, stmt)
		list=[]
		den_tree.stmts.each { |x|
			if x.kind_of?(ForLoop)
				list += stmts_list x, nil
			else
				if stmt == nil
					list += [x]
				elsif x <= stmt 
					list += [x]
				end
			end
		}
		list
	end



	define_rw_rewriter :for_loop_rewriter do
		rewrite :For[:init, :cond, :after, :Block[[:type_decls, :stmts]]] do |node|
			index = for_loop_rewriter lookup(:init)
			stmts = lookup(:stmts).map {|x| stmt_rewriter x}
			ForLoop.new index, stmts
		end
		rewrite :Assignment[:var, :val] do |node|
			lookup(:var)
		end
	end

	define_rw_rewriter :stmt_rewriter do
		rewrite :For[:init, :cond, :after, :body] do |node|
			for_loop_rewriter node
		end
		rewrite :While[:cond, :body] do |node|
			stmts = []
			id = "S" + @stmt_count.to_s
			#stmts += [Statement.new id, [], stmt_rewriter lookup(:cond)]
			@stmt_count += 1
			stmts += stmt_rewriter lookup(:body)
			stmts
		end
		rewrite :If[:test, :conseq, :alt] do |node|
			stmts = []
			id = "S" + @stmt_count.to_s
			#stmts += [Statement.new id, [], stmt_rewriter lookup(:test)]
			@stmt_count += 1
			stmts += stmt_rewriter lookup(:conseq)
			if lookup(:alt) != []
				stmts += stmt_rewriter lookup(:alt)
			end
			stmts
		end
		rewrite :Else[:body] do |node|
			stmt_rewriter lookup(:body)
		end
		rewrite :Block[[:type_decls, :stmts]] do |node|
			stmts = lookup(:stmts).map {|x| stmt_rewriter x}
		end
		rewrite :SimpleStmt[:stmt] do |node|
			re = stmt_rewriter lookup(:stmt)
			
			id = "S" + @stmt_count.to_s
			if re.kind_of?(Assignment)
				stmt = Statement.new id, re.left, re.right
			else
				stmt = Statement.new id, nil, re
			end
			@stmt_count += 1
			stmt
		end
		rewrite :Assignment[:var, :expr] do |node| 
			left = stmt_rewriter lookup(:var)
			right = stmt_rewriter lookup(:expr)
			Assignment.new left[0], right
		end
		rewrite :ArrayRef[:id, :subs] do |node|
			subs = []
			lookup(:subs).each { |x| subs += subs_rewriter x}
			[Variable.new lookup(:id), subs] 
		end
		rewrite :UnaryOp[:op, :var] do |node|
			stmt_rewriter lookup(:var)
		end
		rewrite :Parenthesis[:var] do |node|
			stmt_rewriter lookup(:var)
		end
		rewrite :BinaryOp[:var1, :op, :var2] do |node|
			var1 = stmt_rewriter lookup(:var1)
			var2 = stmt_rewriter lookup(:var2)
			var1 + var2
		end
		rewrite :ConstInt[:val] do |node|
			[]
		end
		rewrite :ConstReal[:val] do |node|
			[]
		end
		default {|node| [Variable.new node, []]}
	end

	define_rw_rewriter :subs_rewriter do
		rewrite :BinaryOp[:var1, :op, :ConstInt[:var2]] do |node|
			op = lookup(:op)
			val = Integer(lookup(:var2))
			if op == "-"
				[Subscript.new lookup(:var1), -val]
			else 
				[Subscript.new lookup(:var1), val]
			end
		end
		rewrite :ConstInt[:val] do |node|
			[]
		end
		default { |node| [Subscript.new node, 0]}
	end

#########################################################################################

	def dependence(stmts1, stmts2, index_list)
		puts "#{stmts1.id} <---> #{stmts2.id} - [#{index_list.join ","}]"
		# to-do 
                ################ directive vector analysis begin

		edges=[] #output value, describing the set of edges
		depLevels=[]
		####### left value of both stmts
		if stmts1.left!=nil && stmts2.left!=nil
                	var1=stmts1.left
			var2=stmts2.left
			depLevels = depLevels+(getDepLevel var1, var2, index_list)
		end


		######## left value of s1 and right values of s2
		if stmts1.left!=nil
			var1=stmts1.left
			vars=stmts2.right
			vars.each{|var2|
				depLevels = depLevels+(getDepLevel var1, var2, index_list)

			}
		end

		######## left value of s2 and right values of s1
		if stmts2.left!=nil
			vars=stmts1.right
			var2=stmts2.left
			vars.each{|var1|
				depLevels = depLevels+(getDepLevel var1, var2, index_list)
			}
		end		

		depLevels = depLevels.uniq
                depLevels.each{|i|
			if not existEdge? edges, stmts1.id, stmts2.id, i
				edges.push Edge.new stmts1.id, stmts2.id, i
			end

		}

		depLevels=[]
		if stmts1.left!=nil
			depLevels = checkRaceCondition(stmts1, index_list)
                	depLevels = depLevels.uniq
                	depLevels.each{|i|
				if not existEdge? edges, stmts1.id, stmts1.id, i
					edges.push Edge.new stmts1.id, stmts1.id, i
				end

			}
		end		
		if stmts2.left!=nil		
                	depLevels = checkRaceCondition(stmts2, index_list)
                	depLevels = depLevels.uniq
                	depLevels.each{|i|
				if not existEdge? edges, stmts2.id, stmts2.id, i
					edges.push Edge.new stmts2.id, stmts2.id, i
				end

			}
		end
			
		edges
	end

	def checkRaceCondition(stmt, index_list)
		depLevels=[]
		index_list.length.times{|i|
			find=false
			if not checkIndex stmt.left, index_list[i]
				find=true
				stmt.right.each{|var|
					if checkIndex var, index_list[i]
						depLevels.push i+1
						find=false
					end
				}
			end
			if find==true
				if checkIdfdVar(stmt)
					depLevels.push i+1
				end
			end
		}
		depLevels

	end

	def checkIdfdVar(stmt)
		find=false
		lvar = stmt.left
		stmt.right.each{|rvar|
			if lvar.id.eql? rvar.id
				find=true
				break
			end
		}
		find
	end

	def checkIndex(var, index_id)
		find=false
		var.subs.each{|sub|
			if sub.var.eql? index_id
				find=true
				break
			end
		}
		find
	end

	def getDepLevel(var1, var2, index_list)
		depLevel=[]
		get=false
		if var1.id.eql? var2.id
		index_list.length.times{|i|
			if get == true
				break;
			end
			index = index_list[i]
			var1.subs.length.times{|j|
				if var1.subs[j].var.eql? index
					if var2.subs.length>j
						if var2.subs[j].var.eql? var1.subs[j].var
							if var2.subs[j].offset - var1.subs[j].offset != 0
								depLevel.push i+1
								get=true
							end
						else
							depLevel.push i+1
							get=true
						end
					end
				end

			}

			var2.subs.length.times{|j|
				if var2.subs[j].var.eql? index
					if var1.subs.length>j
						if var1.subs[j].var.eql? var2.subs[j].var
							if var1.subs[j].offset - var2.subs[j].offset != 0
								depLevel.push i+1
								get=true
							end
						else
							depLevel.push i+1
							get=true
						end
					end
				end

			}
		}
		end

		depLevel= depLevel.uniq
	end

	def existEdge?(edges, sName1, sName2, level)
		exist=false
		edges.each{|edge|
			if (sName1.eql?(edge.node1) && sName2.eql?(edge.node2))||(sName1.eql?(edge.node2) && sName2.eql?(edge.node1))
				if level==edge.level
					exist=true
					break
				end
			end

		}

		exist

	end

	def existLevel?(level, subs)
		exist=false
		subs.each{|sub|
			if sub.var.eql? level
				exist=true
			end		

		}
		exist
	end

########################################################################################

end

class ForLoop
	def initialize(index, stmts)
		@index = index
		@stmts = stmts
	end

	def add_stmt(stmt)
		@stmts += [stmt]
	end

	def to_s
		"for_loop: #{@index} \n #{@stmts.join "\n"}"
	end
	
	attr_accessor  :stmts, :index
end

class Statement
	def initialize(id, left, right)
		@id = id
		@left = left
		@right = right
	end

	def <=(stmt)
		id_num = Integer(stmt.id[1..-1])
		self_id_num = Integer(@id[1..-1])
		if self_id_num <= id_num
			true
		else
			false
		end
	end
	
	def to_s
		":stmt[#{@id}, [#{@left}], [#{@right.join ","}]]"
	end

	attr_accessor :id, :left, :right
end

class Variable
	def initialize(id, subs)
		@id = id
		@subs = subs
	end

	def to_s
		":var[#{@id}, #{@subs.join ","}]"
	end

	attr_accessor :id, :subs
end


class Assignment
	def initialize(left, right)
		@left = left
		@right = right
	end

	attr_accessor :left, :right
end

class Subscript
	def initialize(var, offset)
		@var = var
		@offset = offset
	end

	def to_s
		"[#{@var}, #{@offset}]"
	end

	attr_accessor :var, :offset	
end

class Edge
	def initialize(sName1, sName2, level)
		@node1 = sName1
		@node2 = sName2
		@level = level
	end

	def to_s
		"[#{@node1}, #{@node2}, #{@level}]"
	end

	attr_accessor  :node1, :node2, :level
end
