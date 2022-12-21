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
      attr_accessor :left, :right
      attr_reader :val, :op

      def initialize(val = nil, op = nil, left = nil, right = nil)
        @val = val
        @op = op
        @left = left
        @right = right
      end

      def calc
        @val ||= @left.calc.__send__(@op, @right.calc)
      end
    end

    def human

      0
    end

    def debug!
      @debug = true
    end
  end
end
