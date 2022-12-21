require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Grove
    attr_accessor :debug
    attr_reader :ring, :mult

    def initialize(input, mult = 1)
      @debug = false
      @ring = CircularLinkedList.new input.each_line.map(&:to_i)
      @mult = mult
      @ring.nodes.each do |node|
        node.val *= mult
      end
    end

    def debug!
      @debug = true
    end
    
    def mix
      first = @ring.first
      @ordered_nodes ||= @ring.nodes
      puts "Nodes: #{@ring.to_a(first)}" if @debug
      @ordered_nodes.each do |node|
        next if node.val.zero?
        puts "Shifting: #{node.val % @ring.length}" if @debug
        @ring.shift(node, node.val % (@ring.length - 1))
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
