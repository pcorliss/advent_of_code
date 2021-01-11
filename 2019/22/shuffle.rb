require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'
# require "numeric_inverse"
# using NumericInverse
require 'prime'

module Advent

  class Shuffle
    attr_accessor :debug
    attr_reader :instructions, :deck

    def initialize(input, deck_size = 10007)
      @debug = false
      @deck = Deck.new(deck_size)
      @instructions = input.lines.map(&:chomp).to_a
    end

    def debug!
      @debug = true
    end

    def deal_into_new_stack!
      @deck.reverse!
    end

    def deal_with_increment!(n)
      @deck.deal_with_increment!(n)
    end

    def cut!(n)
      @deck.rotate!(n)
    end

    def run!
      @instructions.each do |inst|
        case inst
        when /^deal into new stack$/
          deal_into_new_stack!
        when /^cut ([\-\d]+)$/
          cut!($1.to_i)
        when /^deal with increment (\d+)$/
          deal_with_increment!($1.to_i)
        else
          raise "Unhandled instruction"
        end
      end
    end
  end

  class Deck
    def initialize(size)
      @size = size
      @inst = []
    end

    def reverse!
      @inst << [:rev, 0]
    end

    def rotate!(n)
      @inst << [:rot, n]
    end

    def deal_with_increment!(n)
      @inst << [:incr, n]
    end

    def calc_offset_and_increment
      @offset = 0
      @increment = 1

      @inst.each do |inst, n|
        case inst
        when :rev
          @increment *= -1
          @offset += @increment
        when :incr
          raise "Deck size is not prime" unless Prime.prime?(@size)
          @increment *= n.pow(@size-2, @size)
        when :rot
          @offset += @increment * n
        end
      end
    end

    def [](i)
      calc_offset_and_increment unless @offset && @increment
      (@offset + @increment * i) % @size
    end

    def to_a
      @size.times.map { |i| self.[](i) }
    end

    def ==(other)
      self.to_a == other
    end
  end
end
