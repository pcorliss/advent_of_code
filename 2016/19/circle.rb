require 'set'
require '../lib/grid.rb'

module Advent

  class Circle
    attr_accessor :debug
    attr_reader :elves, :current_elf

    def initialize(input)
      @debug = false
      @elves = CircularLinkedList.new(input.to_i.times.map {|v| v+1})
      @current_elf = @elves.first
    end

    def debug!
      @debug = true
    end

    def step!
      @elves.destroy(@current_elf.next)
      @current_elf = @current_elf.next
    end
  end

  class CircularLinkedList
    def initialize(values)
      prev_node = nil
      @nodes = values.map do |val|
        new_node = Node.new(val, nil, prev_node)
        prev_node.next = new_node if prev_node
        prev_node = new_node
      end
      prev_node.next = @nodes.first
      @nodes.first.prev = prev_node
    end

    def first
      @nodes.first
    end

    def destroy(node)
      prev_node = node.prev
      next_node = node.next
      prev_node.next = next_node
      next_node.prev = prev_node
    end

    class Node
      attr_accessor :val, :next, :prev
      def initialize(val, n = nil, p = nil)
        @val = val
        @next = n
        @prev = p
      end
    end
  end
end
