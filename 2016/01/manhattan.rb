require 'set'
require '../lib/grid.rb'

module Advent

  class Manhattan
    attr_accessor :debug
    attr_reader :inst, :pos, :direction, :grid

    def initialize(input)
      @debug = false
      @inst = input.split(', ').map do |direction|
        dir, *dist = direction.chars
        [dir, dist.join.to_i]
      end
      @pos = [0,0]
      @direction = 0
      @grid = Grid.new
    end

    def debug!
      @debug = true
    end

    DIR_MAP = {
      0   => [ 0, 1],
      90  => [ 1, 0],
      180 => [ 0,-1],
      270 => [-1, 0],
    }

    def walk!(bail = false)
      @inst.each do |dir, dist|
        case dir
        when 'R'
          @direction += 90
        when 'L'
          @direction -= 90
        end
        @direction %= 360
        delta = DIR_MAP[@direction]
        x, y = delta
        @pos[0] += x * dist
        @pos[1] += y * dist
        @grid.draw!(delta, dist, val = 1, operator = :+)
        if bail && @grid.cells.values.include?(2)
          @pos = @grid.cells.find {|k, v| v == 2}.first
          return
        end
      end
    end

    def distance
      x, y = @pos
      x.abs + y.abs
    end
  end
end
