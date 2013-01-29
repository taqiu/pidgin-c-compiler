cwd = File.dirname(__FILE__)
$:.unshift cwd, cwd + '/RubyWrite/lib'

require 'rubywrite'

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
ReverseLoopNest.run example
