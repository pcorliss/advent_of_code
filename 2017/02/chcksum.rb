require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Chcksum
    attr_accessor :debug
    attr_reader :sheet

    def initialize(input)
      @debug = false
      @sheet = input.each_line.map do |line|
        line.chomp!
        line.split(/\s+/).map(&:to_i)
      end
    end

    def debug!
      @debug = true
    end

    def min_max_diff(digits)
      min, max = digits.minmax
      max - min
    end

    def checksum
      @sheet.sum {|digits| min_max_diff(digits)}
    end

    def evenly_div(digits)
      a, b = digits.combination(2).find do |a, b|
        (a > b && a % b == 0) || (a < b && b % a == 0)
      end

      a > b ? a / b : b / a
    end

    def checksum_div
      @sheet.sum {|digits| evenly_div(digits)}
    end
  end
end
