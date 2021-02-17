require 'set'
require '../lib/grid.rb'

module Advent

  class Circle
    attr_accessor :debug
    attr_reader :elves, :current_elf, :cross_elf

    def initialize(input)
      @debug = false
      @elves = CircularLinkedList.new(input.to_i.times.map {|v| v+1})
      @current_elf = @elves.first
      @cross_elf = @current_elf
      (@elves.length / 2).times { @cross_elf = @cross_elf.next }
    end

    def debug!
      @debug = true
    end

    def step!
      @elves.destroy(@current_elf.next)
      @current_elf = @current_elf.next
    end

    def step_across!
      #elf = @current_elf
      #(@elves.length / 2).times { elf = elf.next }
      @elves.destroy(@cross_elf)
      @current_elf = @current_elf.next
      @cross_elf = @cross_elf.next
      @cross_elf = @cross_elf.next if @elves.length.even?
    end
  end

  class CircularLinkedList
    attr_reader :length

    def initialize(values)
      prev_node = nil
      @nodes = values.map do |val|
        new_node = Node.new(val, nil, prev_node)
        prev_node.next = new_node if prev_node
        prev_node = new_node
      end
      prev_node.next = @nodes.first
      @nodes.first.prev = prev_node
      @length = @nodes.length
    end

    def init_cross!
      @nodes.each_with_index do |n, idx|
        cross_idx = (@length / 2 + idx) % @length
        n.cross = @nodes[cross_idx]
        n.cross.rev_cross = n
      end
    end

    def first
      @nodes.first
    end

    def destroy(node)
      prev_node = node.prev
      next_node = node.next
      cross_node = node.rev_cross
      prev_node.next = next_node
      next_node.prev = prev_node
      cross_node.cross = next_node if cross_node
      @length -= 1
    end

    def render(node = @nodes.first, x = @length)
      n = node
      x.times.map do |i|
        v = n.val
        n = n.next
        v
      end.join("->")
    end

    class Node
      attr_accessor :val, :next, :prev, :cross, :rev_cross
      def initialize(val, n = nil, p = nil)
        @val = val
        @next = n
        @prev = p
      end
    end
  end
end
