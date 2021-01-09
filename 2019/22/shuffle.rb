require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

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
      @deck = size.times.to_a
    end

    def reverse!
      @deck.reverse!
    end

    def rotate!(n)
      @deck.rotate!(n)
    end

    def deal_with_increment!(n)
      new = []
      l = @deck.length
      j = 0
      i = 0
      while j < l do
        new[i % l] = @deck[(i / n) % l]
        i += n
        j += 1
      end
      @deck = new
    end

    def to_a
      @deck
    end

    def ==(other)
      @deck == other
    end
  end
end
