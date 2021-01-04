require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Freq
    attr_accessor :debug
    attr_reader :digits

    BASE = [0, 1, 0, -1]
    def initialize(input)
      @debug = false
      @digits = input.chomp.chars.map(&:to_i)
    end

    def debug!
      @debug = true
    end

    def base_num(repeats, element)
      BASE[((element + 1)/ (repeats + 1)) % BASE.length]
    end

    def phase!
      acc = []
      @digits.each_with_index do |x, i|
        new_digit = 0
        @digits.each_with_index do |d, j|
          sub_digits = d * base_num(i, j)
          if sub_digits >= 10 || sub_digits <= -10
            new_digit += sub_digits.abs % 10
          else
            new_digit += sub_digits
          end
        end
        acc[i] = new_digit.abs % 10
      end
      @digits = acc
    end
  end
end
