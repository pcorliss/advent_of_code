require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Trebuchet
    attr_accessor :debug

    def initialize(input)
      @debug = false
      @lines = input.each_line.map(&:strip)
    end

    STRING_TO_NUM = {
      "one" => 1,
      "two" => 2,
      "three" => 3,
      "four" => 4,
      "five" => 5,
      "six" => 6,
      "seven" => 7,
      "eight" => 8,
      "nine" => 9,
    }
    START_REGEX = /^.*?(one|two|three|four|five|six|seven|eight|nine|\d)/
    END_REGEX = /.*(one|two|three|four|five|six|seven|eight|nine|\d)/

    def nums
      @nums ||= @lines.map do |line|
        line.match(START_REGEX)
        a = $1
        a = STRING_TO_NUM.has_key?(a) ? STRING_TO_NUM[a] : a.to_i
        line.match(END_REGEX)
        b = $1
        b = STRING_TO_NUM.has_key?(b) ? STRING_TO_NUM[b] : b.to_i

        a * 10 + b
      end
    end

    def sum
      nums.sum
    end

    def debug!
      @debug = true
    end
  end
end
