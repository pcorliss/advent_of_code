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

    def collapsed_intervals(y)
      ranges = []
      sensor_intervals(y).sort_by(&:first).each_with_index do |range, idx|
        if idx == 0
          ranges << range if idx == 0
          next
        end

        r = ranges.last
        if range.first <= r.last
          next if range.last < r.last
          ranges.pop
          ranges << (r.first..range.last)
        else
          ranges << range
        end

        puts "Ranges: #{ranges.inspect} #{range} #{idx}" if @debug
      end

      ranges
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

      set
    end

    def find_beacon(coord_a, coord_b)
      (coord_a.last..coord_b.last).each do |y|
        intervals = collapsed_intervals(y)
        if intervals.count > 1
          x = intervals.first.last + 1
          return [x, y]
        end
      end
    end

    def slow_find_beacon(coord_a, coord_b)
      (coord_a.last..coord_b.last).each do |y|
        null_x = null_positions(y)
        (coord_a.first..coord_b.first).each do |x|
          return [x,y] if @grid[x,y].nil? && !null_x.include?(x)
        end
        puts "Y: #{y} Done" if @debug
      end
    end

    def tuning_frequency(coord)
      coord.first * 4000000 + coord.last
    end
  end
end
