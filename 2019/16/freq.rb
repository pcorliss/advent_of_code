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
      BASE[((element + 1)/ (repeats + 1)) % 4]
    end

    def phase!(offset = 0)
      acc = []
      l = @digits.length
      l.times do |i|
        next if i < offset
        new_digit = 0
        l.times do |j|
          b = BASE[((j + 1)/ (i + 1)) % 4]
          next if b == 0
          sub_digits = @digits[j] * b
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

    # def find_loops(i)
    #   looped_digits = 800.times.map { phase![i] }
    #   800.times do |i|
    #     test_digits = looped_digits.first(i + 1)
    #     3.times.all? do |j|
    #       # test_digits == looped_digits[((j*(i+1))..(j+1(i+1)))]
    #     end
    #   end
    # end
  end
end
