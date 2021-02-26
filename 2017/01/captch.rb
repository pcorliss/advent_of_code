require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Captch
    attr_accessor :debug
    attr_reader :digits

    def initialize(input)
      @debug = false
      @digits = input.chomp.chars.map(&:to_i)
    end

    def debug!
      @debug = true
    end
    
    def matches_next_digits(inp)
      acc = []
      inp.chars.each_with_index do |char, idx|
        n = inp[(idx + 1) % inp.length]
        acc << char.to_i if n == char
      end
      acc
    end

    def matches_opposite_digits(inp)
      acc = []
      l = inp.length
      inp.chars.each_with_index do |char, idx|
        n = inp[(idx + l/2) % inp.length]
        acc << char.to_i if n == char
      end
      acc
    end
  end
end
