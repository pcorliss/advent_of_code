require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'


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

end
