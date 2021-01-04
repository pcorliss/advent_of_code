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

    # def phase_slow!(offset = 0)
    #   acc = []
    #   l = @digits.length
    #   l.times do |i|
    #     next if i < offset
    #     new_digit = 0
    #     l.times do |j|
    #       b = BASE[((j + 1)/ (i + 1)) % 4]
    #       next if b == 0
    #       sub_digits = @digits[j] * b
    #       if sub_digits >= 10 || sub_digits <= -10
    #         new_digit += sub_digits.abs % 10
    #       else
    #         new_digit += sub_digits
    #       end
    #     end
    #     acc[i] = new_digit.abs % 10
    #   end
    #   @digits = acc
    # end

    def phase!(offset = 0)
      unless @offset
        @offset = offset
        @digits = @digits[offset..]
      end
      acc = []
      l = @digits.length + @offset
      i = l - 1
      while i >= offset do
        new_digit = 0
        (i..(l-1)).each do |j|
          b = BASE[((j + 1)/ (i + 1)) % 4]
          next if b == 0
          new_digit += @digits[j - @offset] * b
        end
        acc[i - @offset] = new_digit.abs % 10
        i -= 1
      end
      @digits = acc
    end

    def set_offset(offset)
      @offset = offset
      @digits = @digits[offset..]
    end

    # For part two all numbers will have a base of 1, no negatives or zeros.
    # Because of that we can just use the reverse cumlative sum
    def phase_ignore_base
      acc = []
      l = @digits.length + @offset
      i = l - 1
      sum = 0
      while i >= @offset do
        sum += @digits[i - @offset]
        acc[i - @offset] = sum % 10
        i -= 1
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
