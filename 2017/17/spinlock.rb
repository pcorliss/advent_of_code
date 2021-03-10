require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Spinlock
    attr_accessor :debug
    attr_reader :skip, :ring, :length, :pos, :last_val, :val_next

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

    def fake_step!
      @length ||= 1
      @val_next ||= 0
      @last_val += 1
      @pos ||= 0
      #@skip.times { @current_node = @current_node.next }
      @pos += @skip
      @pos %= @length
      puts "Inserting #{@last_val} after 0" if @debug && @pos == 0
      @val_next = @last_val if @pos == 0
      #@ring.add(@current_node, @last_val)
      @length += 1
      @pos += 1
      @pos %= @length
    end
  end
end
