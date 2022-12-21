require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Grove
    attr_accessor :debug
    attr_reader :ring

    def initialize(input)
      @debug = false
      @ring = CircularLinkedList.new input.each_line.map(&:to_i)
    end

    def debug!
      @debug = true
    end
    
    def mix
      first = @ring.first
      nodes = @ring.nodes
      puts "Nodes: #{@ring.to_a(first)}" if @debug
      nodes.each do |node|
        @ring.shift(node, node.val)
        puts "Nodes: #{@ring.to_a(first)} Shifted: #{node.val}" if @debug
      end
      @ring
    end

    def coords
      zero = @ring.nodes.find { |n| n.val == 0 }
      array = @ring.to_a(zero)
      [
        array[1000 % array.length],
        array[2000 % array.length],
        array[3000 % array.length],
      ]
    end
  end
end
