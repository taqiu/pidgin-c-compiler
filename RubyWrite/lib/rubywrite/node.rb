module RubyWrite
  # Node is the internal node type of trees constructed within RubyWrite.  Other
  # node types are Array (anonymous internal node) and leaf node types String, and Symbol.
  # The definition of Node allows any object to be contained in its "value" field.
  # Normally, the value is a Symbol that serves to label an internal node.
  class Node
    attr_reader :value
    attr_accessor :children
    attr_accessor :attributes

    def initialize (v, c=[], a = {})
      @value = v
      @children = []
      c.each {|x| @children << x}
      # performing a deep copy may be a better idea?
      @attributes = a.clone
    end

    def self.concrete str
      ConcreteNode.new(str)
    end

    def numChildren
      @children.length
    end

    def child (i)
      @children[i]
    end

    def each_child
      @children.each {|x| yield x }
    end

    def each_child_index
      @children.each_index {|i| yield i }
    end

    def each_child_with_index
      @children.each_with_index {|x,i| yield x,i }
    end

    def set_attr k, v
      @attributes[k] = v
    end

    def get_attr k
      @attributes[k]
    end

    def to_s
      "Node{val=#{value.to_s}, numChildren=#{@children.length}}"
    end

    def ==(term) 
      self.class == term.class and @value == term.value and @children == term.children
    end

    def xform *args
      n = self
      args.each { |c| n = (c.instance_of?(Class)) ? c.run(n) : c.main(n) }
      n
    end

    # Node is a valid tree
    def valid_tree?
      true
    end
  end

  # Indicates a concrete class, since the base functionality we want for
  # concrete classes treats them more like fixed strings then code, we'd like
  # to subclass string.  The wrapper class allows us to distinguish a normal
  # string from a concrete node, should we need to reconstitute it, into a
  # normal node.
  #
  # Just to be clear, since the node hierarchy doesn't know anything about the
  # concrete syntax of the language being analyzed, it doesn't know what the
  # value of the node is, or how to recreate the parsed nodes.
  class ConcreteNode < String
  end
end


class Array
  # Array is treated as an anonymous node, so it has children
  alias each_child each
  alias each_child_index each_index
  alias each_child_with_index each_with_index
  alias children= replace
  alias numChildren length

  def children
    self
  end

  def xform *args
    n = self
    args.each { |c| n = (c.instance_of?(Class)) ? c.run(n) : c.main(n) }
    n
  end

  # Array is a valid tree
  def valid_tree?
    true
  end
end


class String
  # default each_child does nothing
  def each_child
  end

  # default each_child_with_index does nothing
  def each_child_with_index
  end

  # default each_child_index does nothing
  def each_child_index
  end

  # default children= does nothing
  def children= (c)
  end

  def xform *args
    n = self
    args.each { |c| n = (c.instance_of?(Class)) ? c.run(n) : c.main(n) }
    n
  end

  # String is a valid tree
  def valid_tree?
    true
  end
end

class Symbol
  # Extend the Symbol class with the [] operator as a convenience for creating trees
  def [] (*args, &p)
    RubyWrite::Node.new(self, args)
  end
end

class Object
  # The default object has no valid child (0 indicates valid children, so we return -1).
  def numChildren
    -1
  end

  # Default object is not a valid tree
  def valid_tree?
    false
  end
end
