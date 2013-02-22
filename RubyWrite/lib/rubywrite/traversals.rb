require 'rubywrite/basic'

module RubyWrite
  module Traversals
    include RubyWrite::Basic

    module ClassMethods
      def define_rw_preorder name, &blk
        st = SimpleTraversal.new
        st.instance_exec &blk
        define_method name do |*args|
          st.preorder self, *args
        end
      end

      def define_rw_postorder name, &blk
        st = SimpleTraversal.new
        st.instance_exec &blk
        define_method name do |*args|
          st.postorder self, *args
        end
      end

      def define_rw_rpreorder name, &blk
        st = SimpleTraversal.new
        st.instance_exec &blk
        define_method name do |*args|
          st.rpreorder self, *args
        end
      end

      def define_rw_rpostorder name, &blk
        st = SimpleTraversal.new
        st.instance_exec &blk
        define_method name do |*args|
          st.rpostorder self, *args
        end
      end
    end

    class SimpleTraversal
      def initialize
        @handlers = {}
        @default = nil
      end

      def upon *node_types, &blk
        node_types.each {|node_type| @handlers[node_type] = blk}
      end

      def upon_default &blk
        @default = blk
      end

      def preorder xfer, node, *args
        apply xfer, node, *args
        if node.respond_to? :children
          node.children.map! { |c| preorder xfer, c, *args }
        end
        node
      end

      def postorder xfer, node, *args
        if node.respond_to? :children
          node.children.map! { |c| postorder xfer, c, *args }
        end
        apply xfer, node, *args
        node
      end

      def rpreorder xfer, node, *args
        apply xfer, node, *args
        if node.respond_to? :children
          c = node.children.reverse.map { |c| rpreorder xfer, c, *args}
          node.children = c.reverse
        end
        node
      end

      def rpostorder xfer, node, *args
        if node.respond_to? :children
          c = node.children.reverse.map { |c| rpostorder xfer, c, *args }
          node.children = c.reverse
        end
        apply xfer, node, *args
        node
      end

      private

      def apply xfer, node, *args
        raise Fail, "RubyWrite::SimpleTraversal#apply: Unexpected nil node" if !node
        begin
          saved_env = xfer.env
          xfer.env = Environment.new
          code = (node.respond_to?(:value) && @handlers[node.value]) || @default
          raise Fail, "RubyWrite::SimpleTraversal#apply: No rule to match #{node.to_string}" if !code
          xfer.instance_exec node, *args, &code
        ensure
          xfer.env = saved_env
        end
      end
    end

    def self.included base
      base.extend ClassMethods
    end

    def all! (node, &blk)
      return node if node.numChildren <= 0
      new_children = []
      node.each_child do |c|
        if (t = try(c, &blk))
          new_children << t
        else
          raise Fail.new("RubyWrite::all! failed on node \"#{c.to_string}\"")
        end
      end
      node.children = new_children
      node
    end

    def is_all? (node, &blk)
      return true if node.numChildren <= 0
      node.each_child {|c| return false if !try(c, &blk) }
      true
    end

    def one! (node, &blk)
      return node if node.numChildren <= 0
      node.each_child_with_index do |c, i|
        if (t = try(c, &blk))
          node.children[i] = t
          return node
        end
      end
      raise Fail.new("RubyWrite::one! failed on node \"#{node.to_string}\"")
    end

    def one? (node, &blk)
      return true if node.numChildren <= 0
      node.each_child {|c| return true if try(c, &blk) }
      false
    end

    def alltd! (node, &blk)
      if (t = try(node, &blk))
        t
      else
        all!(node) {|n| alltd!(n, &blk)}
      end
    end

    def alltd? (node, &blk)
      if try(node, &blk)
        true
      else
        is_all?(node) {|n| alltd?(n, &blk)}
      end
    end

    def topdown! (node, &blk)
      if (n = try(node, &blk))
        n.each_child_with_index do |c, i|
          if (t = topdown!(c, &blk))
            n.children[i] = t
          else
            raise Fail.new("RubyWrite::topdown! failed on node \"#{c}\"")
          end
        end
        n
      else
        raise Fail.new("RubyWrite::topdown! failed on node \"#{n.to_string}\"")
      end
    end

    def topdown? (node, &blk)
      return false if !try(node, &blk)
      node.each_child {|c| return false if !topdown?(c, &blk) }
      true
    end

    def bottomup! (node, &blk)
      node.each_child_with_index do |c, i|
        if (t = bottomup!(c, &blk))
          node.children[i] = t
        else
          raise Fail.new("RubyWrite::bottomup! failed on node \"#{c.to_string}\"")
        end
      end
      if (n = try(node, &blk))
        n
      else
        raise Fail.new("RubyWrite::bottomup! failed on node \"#{n.to_string}\"")
      end
    end

    def bottomup? (node, &blk)
      node.each_child {|c| return false if !bottomup?(c, &blk) }
      return false if !try(node, &blk)
      true
    end
  end

  class Node
    def all! (code)
      code.xer.all!(self) {|*a| code.call *a}
    end

    def is_all? (code)
      code.xer.is_all?(self) {|*a| code.call *a}
    end

    def one! (code)
      code.xer.one!(self) {|*a| code.call *a}
    end

    def one? (code)
      code.xer.one?(self) {|*a| code.call *a}
    end

    def alltd! (code)
      code.xer.alltd!(self) {|*a| code.call *a}
    end

    def alltd? (code)
      code.xer.alltd?(self) {|*a| code.call *a}
    end

    def topdown! (code)
      code.xer.topdown!(self) {|*a| code.call *a}
    end

    def topdown? (code)
      code.xer.topdown?(self) {|*a| code.call *a}
    end

    def bottomup! (code)
      code.xer.bottomup!(self) {|*a| code.call *a}
    end

    def bottomup? (code)
      code.xer.bottomup?(self) {|*a| code.call *a}
    end
  end
end


class Array
  def all! (code)
    code.xer.all!(self) {|*a| code.call *a}
  end

  def is_all? (code)
    code.xer.is_all?(self) {|*a| code.call *a}
  end

  def one! (code)
    code.xer.one!(self) {|*a| code.call *a}
  end

  def one? (code)
    code.xer.one?(self) {|*a| code.call *a}
  end

  def alltd! (code)
    code.xer.alltd!(self) {|*a| code.call *a}
  end

  def alltd? (code)
    code.xer.alltd?(self) {|*a| code.call *a}
  end

  def topdown! (code)
    code.xer.topdown!(self) {|*a| code.call *a}
  end

  def topdown? (code)
    code.xer.topdown?(self) {|*a| code.call *a}
  end

  def bottomup! (code)
    code.xer.bottomup!(self) {|*a| code.call *a}
  end

  def bottomup? (code)
    code.xer.bottomup?(self) {|*a| code.call *a}
  end
end


class String
  def all! (code)
    code.xer.all!(self) {|*a| code.call *a}
  end

  def is_all? (code)
    code.xer.is_all?(self) {|*a| code.call *a}
  end

  def one! (code)
    code.xer.one!(self) {|*a| code.call *a}
  end

  def one? (code)
    code.xer.one?(self) {|*a| code.call *a}
  end

  def alltd! (code)
    code.xer.alltd!(self) {|*a| code.call *a}
  end

  def alltd? (code)
    code.xer.alltd?(self) {|*a| code.call *a}
  end

  def topdown! (code)
    code.xer.topdown!(self) {|*a| code.call *a}
  end

  def topdown? (code)
    code.xer.topdown?(self) {|*a| code.call *a}
  end

  def bottomup! (code)
    code.xer.bottomup!(self) {|*a| code.call *a}
  end

  def bottomup? (code)
    code.xer.bottomup?(self) {|*a| code.call *a}
  end
end
