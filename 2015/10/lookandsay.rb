require 'set'
require '../lib/grid.rb'

module Advent

  class LookAndSay
    attr_accessor :debug
    attr_reader :input

    def initialize(input)
      @debug = false
      @input = input.chomp.chars.map(&:to_i)
      @current = @input
    end

    def debug!
      @debug = true
    end

    def step
      result = []
      current_digit = @current.first
      current_digit_count = 0
      @current.each do |digit|
        if digit == current_digit
          current_digit_count += 1
        else
          result << current_digit_count
          result << current_digit
          current_digit = digit
          current_digit_count = 1
        end
      end
      result << current_digit_count
      result << current_digit

      @current = result
    end
  end
end
