require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require '../lib/cycle_detection.rb'

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

    def transpose(x, y, direction)
      case direction
      when :north
        return [x, y]
      when :west
        return [y, x]
      when :south
        return [x, @grid.height - y - 1]
      when :east
        return [@grid.width - y - 1, x]
      end
    end

    def tilt!(direction = :north)
      @grid.width.times do |x|
        blocker = -1
        @grid.height.times do |y|
          t_x, t_y = transpose(x, y, direction)
          val = @grid[t_x, t_y]
          case val
          when 'O'
            new_y = blocker + 1
            if new_y < y
              @grid[t_x, t_y] = '.'
              @grid[transpose(x, new_y, direction)] = 'O' 
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

    def spin!
      tilt!(:north)
      tilt!(:west)
      tilt!(:south)
      tilt!(:east)
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

    def multi_spin_load(cycles)
      cd = Advent::CycleDetection.new(min_repeats: 3, max_cycle_length: 30, min_cycle_length: 5) do |i|
        spin!
        total_load
      end

      cycle_length = cd.cycle_finder
      cycle_start = cd.cycle_first_index

      # cd.results[(cycles - cycle_start) % cycle_length + cycle_start - 1]
      cd[cycles - 1]
    end
  end
end
