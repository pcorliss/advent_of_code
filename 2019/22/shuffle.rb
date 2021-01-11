require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'
require "numeric_inverse"
using NumericInverse

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
      # @deck.reverse!
      @inst << [:rev, 0]
    end

    def rotate!(n)
      # @deck.rotate!(n)
      @inst << [:rot, n]
    end

    def deal_with_increment!(n)

      @inst << [:incr, n]
    end

    def [](i)
      acc = i
      @inst.each do |inst, n|
        case inst
        when :rev
          acc = @size - acc - 1
        when :incr
          new_d = []
          oth_d = []
          deck = @size.times.to_a
          l = @size
          j = 0
          k = 0
          while j < l do
            new_d[k % l] = deck[(k / n) % l]
            oth_d[k] = deck[(k / n) % l]
            k += n
            j += 1
          end
          acc = new_d[i]
        when :rot
          acc = (acc + n) % @size
        end
      end
      acc
    end

    def to_a
      @size.times.map { |i| self.[](i) }
    end

    def ==(other)
      self.to_a == other
    end
  end
end
