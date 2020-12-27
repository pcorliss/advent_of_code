require 'set'

module Advent

  class Memory

    attr_reader :first, :last, :turn, :prev

    def initialize(input)
      @turn = 0
      @first = {}
      @last = {}
      @prev = 0
      input.chomp.split(",").each do |n|
        @turn += 1
        @last[n.to_i] = @turn
        @first[n.to_i] = @turn
        @prev = n.to_i
      end
    end

    def step!
      num_to_speak = nil
      if @first[@prev] == @turn
        num_to_speak = 0
      else
        num_to_speak = @last[@prev] - @first[@prev]
        @first[@prev] = @last[@prev]
      end
      @turn += 1
      @last[num_to_speak] = @turn
      @first[num_to_speak] ||= @turn
      @prev = num_to_speak
    end

    def goto_turn!(t)
      n = nil
      while @turn < t do
        n = step!
      end
      n
    end
  end
end
