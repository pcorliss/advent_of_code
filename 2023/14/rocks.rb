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

    def cycle_detection(&block)
      results = []
      200.times do |i|
        results << block.call(i)
      end

      cycle = nil
      (5..100).each do |i|
        a, b, c, _ = results.each_slice(i).to_a.last(4)
        if a == b && b == c
          cycle = a
          break
        end
      end

      raise "Unable to find cycle" if cycle.nil?
      puts "Found Cycle: #{cycle}" if @debug

      cycle_start = nil
      results.each_with_index do |i, idx|
        if i == cycle.first && results[idx..(idx+cycle.length-1)] == cycle
          cycle_start = idx
          break
        end
      end

      raise "Unable to find cycle start" if cycle_start.nil?
      puts "Found Cycle Start: #{cycle_start}" if @debug

      [cycle, cycle_start]
    end

    def multi_spin_load(cycles)
      cycle, cycle_start = cycle_detection do |i|
        spin!
        total_load
      end

      cycle[(cycles - cycle_start) % cycle.length - 1]
    end
  end
end
