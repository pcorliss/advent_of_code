module Advent
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
      @first = @nodes.first
    end

    # There's a bug here where the first node can be destroyed
    def first
      @first
    end

    def destroy(node)
      prev_node = node.prev
      next_node = node.next
      prev_node.next = next_node
      next_node.prev = prev_node
      @length -= 1
      @first = node.next if node == @first
    end

    def add(node, val)
      n = nil
      if val.is_a? Node
        n = val
        n.next = node.next
        n.prev = node
      else
        n = Node.new(val, node.next, node)
      end
      @nodes << n
      @length += 1
      node.next.prev = n
      node.next = n
    end

    def render(node = @nodes.first, x = @length)
      to_a(node, x).join('->')
    end

    def to_a(node = @nodes.first, x = @length)
      nodes(node, x).map(&:val)
    end

    def nodes(node = @nodes.first, x = @length)
      n = node
      x.times.map do |i|
        p = n
        n = n.next
        p
      end
    end

    def shift(node, amount)
      return if amount == 0
      destroy(node)
      n = node.prev # 0

      if amount >= 0
        amount.times { n = n.next } # 2, 3
      else
        amount.abs.times { n = n.prev } # 4, 3, 2
      end

      add(n, node)
    end

    def reverse(node, length)
      return if length <= 1
      # This node is before the reversing and needs it's next updated # to the last node
      pre_node = node.prev
      # This node is after the last node reversed and needs it's prev updated to the first node
      pos_node = nil
      first_node = node
      n = node
      last_node = nil

      length.times do |i|
        tmp = n.next
        n.next = n.prev
        n.prev = tmp

        last_node = n
        n = n.prev
        pos_node = n
      end

      if length < @length
        pos_node.prev = first_node
        first_node.next = pos_node

        last_node.prev = pre_node
        pre_node.next = last_node
      end
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
