require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Hail
    attr_accessor :debug
    attr_reader :hail

    def initialize(input)
      @debug = false
      @hail = input.each_line.map do |line|
        pos, vel = line.split('@')
        pos = pos.split(',').map(&:to_i)
        vel = vel.split(',').map(&:to_i)
        [pos, vel]
      end
    end

    def debug!
      @debug = true
    end

    def fit_line(hail)
      pos, vel = hail
      x, y, z = pos
      vx, vy, vz = vel
      # 0 = ax + by + c
      a = vy / vx.to_f
      c = y - x * a
      b = -1
      [a, b, c]
    end

    def intersection(l1, l2)
      a1, b1, c1 = l1
      a2, b2, c2 = l2
      x = (b1 * c2 - b2 * c1) / (a1 * b2 - a2 * b1)
      y = (a2 * c1 - a1 * c2) / (a1 * b2 - a2 * b1)
      [x, y]
    end

    def in_the_past?(h1, h2, x, y)
      (x1, y1, _), (dx1, dy1, _) = h1
      (x2, y2, _), (dx2, dy2, _) = h2
   
      # binding.pry if @debug
      (x - x1) / dx1 < 0 || (x - x2) / dx2 < 0 ||
        (y - y1) / dy1 < 0 || (y - y2) / dy2 < 0
    end

    def matching_intersections(bounds)
      bx1, by1 = bounds.first
      bx2, by2 = bounds.last

      lines_map = {}
      @hail.each do |hail|
        lines_map[hail] = fit_line(hail)
      end

      count = 0

      @hail.combination(2).each do |h1, h2|
        (x1, _, _), _ = h1
        (x2, _, _), _ = h2
        l1 = lines_map[h1]
        l2 = lines_map[h2]
        x, y = intersection(l1, l2)
        in_bounds = x.between?(bx1, bx2) && y.between?(by1, by2)
        in_past = in_the_past?(h1, h2, x, y)
        no_intersection = x.abs == Float::INFINITY || y.abs == Float::INFINITY

        if @debug
          puts "Hailstone A: #{h1.inspect}"
          puts "Hailstone B: #{h2.inspect}"
          if in_past
            puts "Hailstones' paths crossed in the past."
          elsif no_intersection
            puts "Hailstones' paths will never cross."
          else
            puts "Hailstones' paths will cross #{in_bounds ? 'inside' : 'outside'} the test area (at #{[x,y]})."
          end
          puts ""
        end

        count += 1 if !in_past && in_bounds && !no_intersection
      end

      count
    end
  end
end
