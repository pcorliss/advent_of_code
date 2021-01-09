require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Shuffle
    attr_accessor :debug
    attr_reader :deck, :instructions

    def initialize(input, deck_size = 10007)
      @debug = false
      @deck = deck_size.times.to_a
      @instructions = input.lines.map(&:chomp).to_a
    end

    def debug!
      @debug = true
    end

    def deal_into_new_stack!
      @deck.reverse!
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
end
