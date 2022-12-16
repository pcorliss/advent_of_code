require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Beacons
    attr_accessor :debug
    attr_reader :grid, :sb_pairs

    def initialize(input)
      @debug = false
      @grid = Grid.new
      @sb_pairs = []
      input.each_line do |line|
        line.chomp!

        if line =~ /x=([-\d]+), y=([-\d]+).*x=([-\d]+), y=([-\d]+)/
          s = [$1.to_i, $2.to_i]
          b = [$3.to_i, $4.to_i]
          @grid[s] = 'S'
          @grid[b] = 'B'
          @sb_pairs << [s, b]
        end
      end
    end

    def debug!
      @debug = true
    end

    def sensor_intervals(y)
      @sb_pairs.map do |s, b|
        s_x, s_y = s
        b_x, b_y = b
        range = (s_x - b_x).abs + (s_y - b_y).abs
        x_variance = range - (s_y - y).abs

        next if x_variance.negative?

        min_x = s_x - x_variance
        max_x = s_x + x_variance
        (min_x..max_x)
      end.compact
    end

    def null_positions(y)
      set = Set.new
      sensor_intervals(y).each do |range|
        set.merge(range)
      end

      @sb_pairs.each do |s, b|
        b_x, b_y = b
        set.delete b_x if b_y == y
      end

      set.count
    end
  end
end
