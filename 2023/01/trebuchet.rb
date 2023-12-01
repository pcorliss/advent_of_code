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

    def nums
      @nums ||= @lines.map do |line|
        numbers_in_string = line.scan(/\d/).map(&:to_i)
        a = numbers_in_string.first
        b = numbers_in_string.last
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
