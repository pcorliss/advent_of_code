require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Rocks
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
    end

    def debug!
      @debug = true
    end

    def tilt!
      @grid.width.times do |x|
        blocker = -1
        @grid.height.times do |y|
          val = @grid[x,y]
          case val
          when 'O'
            new_y = blocker + 1
            if new_y < y
              @grid[x,y] = '.'
              @grid[x,new_y] = 'O' 
              blocker += 1
            else
              blocker = y
            end
          when '#'
            blocker = y
          when '.'
          else
            raise "Unexpected value #{val} at #{x},#{y}"
          end
        end
      end
    end

    def total_load
      @grid.cells.sum do |(x, y), val|
        if val == 'O'
          @grid.height - y
        else
          0
        end
      end
    end
  end
end
