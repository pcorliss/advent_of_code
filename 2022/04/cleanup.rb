require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Cleanup
    attr_accessor :debug
    attr_reader :ranges

    def initialize(input)
      @debug = false
      @ranges = []
      input.each_line do |line|
        line.chomp!
        a, b, c, d = line.split(/[,\-]/).map(&:to_i)
        @ranges.push([a..b, c..d])
      end
    end

    def debug!
      @debug = true
    end

    def cover?(two_ranges)
      a, b = two_ranges
      return true if a.cover? b
      return true if b.cover? a
      false
    end

    def overlap?(two_ranges)
      a, b = two_ranges
      return true if a.include?(b.first)|| a.include?(b.last)
      return true if b.include?(a.first)|| b.include?(a.last)
      false
    end

    def count_cover
      ranges.count { |r| cover?(r) }
    end

    def count_overlap
      ranges.count { |r| overlap?(r) }
    end
  end
end
