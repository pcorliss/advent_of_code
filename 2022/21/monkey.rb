require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Monkey
    attr_accessor :debug
    attr_reader :instructions

    def initialize(input)
      @debug = false
      @instructions = {}
      input.each_line do |line|
        line.chomp!
        k, insts = line.split(': ')
        parts = insts.split(' ')
        @instructions[k.to_sym] = []
        parts.each do |part|
          if part =~ /^\d+$/
            @instructions[k.to_sym] << part.to_i
          else
            @instructions[k.to_sym] << part.to_sym
          end
        end
      end
    end

    def node_tree
      return @nodes if @nodes
      @nodes = {}
      @instructions.each do |key, insts|
        if insts.length == 1
          @nodes[key] = MonkeyNode.new(insts.first)
        else
          a, op, b = insts
          @nodes[key] = MonkeyNode.new(nil, op, a, b)
        end
      end

      @nodes.each do |key, node|
        node.left = @nodes[node.left] if node.left.is_a? Symbol
        node.right = @nodes[node.right] if node.right.is_a? Symbol
      end
      @nodes
    end

    def lookup(key)
      node_tree[key].calc
    end

    # root is actually a binary tree
    # Could also just use parans and expansion to generate a long query then eval it
    # Technicall only need to solve half the tree
    
    class MonkeyNode
      attr_accessor :left, :right, :val, :op

      def initialize(val = nil, op = nil, left = nil, right = nil)
        @val = val
        @op = op
        @left = left
        @right = right
      end

      def calc
        return @val if @val
        return nil unless @left && @right
        @left.calc
        @right.calc
        return nil unless @left.val && @right.val
        @val ||= @left.calc.__send__(@op, @right.calc)
      end

      def solve!
        return unless @left && @right
        # @left.calc if @left.val.nil?
        # @right.calc if @right.val.nil?

        return if @left.val && @right.val

        if @op == :+
          if @left.val.nil?
            @left.val = @val - @right.val
          else
            @right.val = @val - @left.val
          end
        elsif @op == :-
          if @left.val.nil?
            # 10 = X - 3
            # 10 + 3 == X
            @left.val = @val + @right.val
          else
            # 10 = 13 - X
            # (10 - 13) * -1 == X
            @right.val = (@val - @left.val) * -1
          end
        elsif @op == :*
          # 21 = X * 3
          # 21 / 3 == X
          if @left.val.nil?
            @left.val = @val / @right.val
          else
            @right.val = @val / @left.val
          end
        elsif @op == :/
          # 3 = X / 7
          # 3 * 7 == X
          if @left.val.nil?
            @left.val = @val * @right.val
          # 3 = 21 / X
          # X == 21 / 3
          else
            @right.val = @left.val / @val
          end
        elsif @op == :==
          if @left.val.nil?
            @left.val = @right.val
          else
            @right.val = @left.val
          end
        end

        @left.solve!
        @right.solve!
        calc
      end
    end

    def human
      # Force Re-Init
      @nodes = nil
      # Set Root to `==`
      node_tree[:root] = MonkeyNode.new(nil, :==, node_tree[:root].left, node_tree[:root].right)
      # Nil out Human Entry
      node_tree[:humn].val = nil

      puts "Starting Calc of Root" if @debug
      node_tree[:root].calc
      puts "Starting Solve of Root" if @debug
      node_tree[:root].solve!

      node_tree[:humn].val
    end

    def debug!
      @debug = true
    end
  end
end
