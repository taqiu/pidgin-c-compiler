#! /usr/bin/ruby

cwd = File.dirname(__FILE__)
$:.unshift cwd, cwd + '/RubyWrite/lib'

require 'rubywrite'
require 'PCParse/scanner'
require 'PCParse/pcparser'
require 'PCUnparse/pcunparser'
require 'CSA/pccsa'
require 'LLVM/pcllvm'
require 'LLVM/llvmunparser'
require 'Project/auto_parallel'
require 'optparse'

# This class includes RubyWrite as a module.  So, the class can use RubyWrite
# features.  RubyWrite method become this class's methods.
class ReverseLoopNest
  include RubyWrite

  # The main method uses a helper rewriter method.  The helper is not really
  # necessary, but it's here as an example of how to write a rewriter method.
  define_rw_method :main do |node|
    alltd? node do |n|
      if match? :Body[:stmt_list], n
        # If we find a Body, iterate over each statement
        lookup(:stmt_list).each {|s| find_for_loop s}
        true   # return true to indicate that there's no need to traverse the tree deeper
      else
        false  # return false to continue deeper into the tree until we hit :Body node
      end
    end
  end

  define_rw_rewriter :find_for_loop do
    rewrite :For[:_,:_,:_,:_] do |n|
      puts 'Found FOR-loop'
      n.prettyprint STDOUT
      puts
    end
    default do |n|
      # Do nothing in all other cases
    end
  end
end


# The driver code follows.  Note that it is not inside any class definition.
# (actually, by default, it is added to Object class)
# The following code cannot use RubyWrite constructs, because RubyWrite has
# not been included as a module within the top-level Object class.
example = :Function[:Name['tmp'],
                    :Body[[:Assignment[:Var['x'], '=', :Const['10']],
                           :For[:Var['i'],
                                :Const['1'],
                                :Const['10'],
                                :Body[[:For[:Var['j'],
                                           :Const['1'],
                                           :Var['x'],
                                           :Body[[:Assignment[:SubsRef[:Var['A'],[:Var['i'],:Var['j']]],
                                                              '=',
                                                              :BinOp[:SubsRef[:Var['A'],[:Var['i'],:Var['j']]],
                                                                     '+',
                                                                     :Const['10']
                                                                    ]
                                                             ]
                                                 ]
                                                ]
                                           ]
                                      ]]
                               ]
                          ]
                         ]
                   ]
#ReverseLoopNest.run example
#exit
######################### my code begin #################################

# parse the argments
options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: pcc.rb [options]"
	options[:parse] = false
	options[:ccode] = false
	options[:llvm]  = false
	options[:autoparallel] = false

	opts.on("-p", "--[no-]parse", "Display a parse tree") do |v|
		options[:parse] = v
	end
	opts.on("-c", "--[no-]ccode", "Output unparsed c-code") do |v|
		options[:ccode] = v
	end
	opts.on("-l", "--[no-]llvm", "Display the AST of llvm") do |v|
		options[:llvm] = v
	end
	opts.on("-a", "--[no-]autoparallel", "Output auto parallel OpenMP code") do |v|
		options[:autoparallel] = v
	end
end.parse!

# p options
# p ARGV
# exit

# scan the code
scanner = Scanner.new
scanned_words = []
while true
	t = scanner.next_token
	scanned_words.push [t[0], t[1]]	
	break if t[0] == false
end

#p scanned_words
#exit

# parse the code
parser = PCParser.new
syntax_tree = parser.parse_array scanned_words

# print syntax tree if need
if options[:parse] 
	syntax_tree.prettyprint STDOUT
	puts
	exit
end

# context-sence analysis
exit unless PCCSA.run syntax_tree

# unparser the syntax tree
if options[:ccode]
	unparser = PCUnparser.new
	puts unparser.unparse syntax_tree
	exit
end

# oupt the auto paralell OpenMP code
if options[:autoparallel]
	past = AutoParallel.run syntax_tree
	#past.prettyprint STDOUT
	#puts
	unparser = PCUnparser.new
	puts unparser.unparse past
	exit
end

# rewrite c ast to llvm ast
llvm_ast = PCLLVM.run syntax_tree

# print syntax tree of llvm code
if options[:llvm]
	llvm_ast.prettyprint STDOUT
	puts
	exit
end

if llvm_ast != nil
	llvm_unparser = LLVMUnparser.new
	puts llvm_unparser.unparse llvm_ast
end

########################## my code end ##################################

