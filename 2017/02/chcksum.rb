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
      @sheet.map {|digits| min_max_diff(digits)}.sum
    end
  end
end
