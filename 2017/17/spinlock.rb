require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Spinlock
    attr_accessor :debug
    attr_reader :skip, :ring

    def initialize(input)
      @debug = false
      @skip = input.to_i
      @ring = CircularLinkedList.new([0])
      @last_val = 0
      @current_node = @ring.first
    end

    def debug!
      @debug = true
    end

    def step!
      @last_val += 1
      @skip.times { @current_node = @current_node.next }
      puts "Inserting #{@last_val} after 0" if @debug && @current_node == @ring.first
      @ring.add(@current_node, @last_val)
      @current_node = @current_node.next
    end
  end
end
