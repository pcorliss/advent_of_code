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
    end

    def first
      @nodes.first
    end

    def destroy(node)
      prev_node = node.prev
      next_node = node.next
      prev_node.next = next_node
      next_node.prev = prev_node
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
      attr_accessor :val, :next, :prev
      def initialize(val, n = nil, p = nil)
        @val = val
        @next = n
        @prev = p
      end
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

    def first
      @nodes.first
    end

    def destroy(node)
      prev_node = node.prev
      next_node = node.next
      prev_node.next = next_node
      next_node.prev = prev_node
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
      attr_accessor :val, :next, :prev
      def initialize(val, n = nil, p = nil)
        @val = val
        @next = n
        @prev = p
      end
    end
  end
end
