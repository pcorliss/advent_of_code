require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class RecursiveDonut
    attr_accessor :debug
    attr_reader :grid
    attr_reader :points

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      map_points!
    end

    def map_points!
      @points = {}
      min_y, max_y = @grid.cells.keys.map(&:last).minmax
      min_x, max_x = @grid.cells.keys.map(&:first).minmax

      @grid.cells.each do |cell, val|
        if val.match(/^[A-Z]$/)
          x, y = cell

          outside = x < (2+min_x) || y < (2+min_y) || y > (max_y-2) || x > (max_x-2) ? 1 : -1

          right_cell = @grid[x + 1, y]
          double_right_cell = @grid[x + 2, y]
          left_cell = @grid[x - 1, y]
          if right_cell && right_cell.match(/^[A-Z]$/) && (double_right_cell == '.' || left_cell == '.')
            @points[val + right_cell] ||= []
            if double_right_cell == '.'
              @points[val + right_cell] << [x + 2, y, outside]
            end
            if left_cell == '.'
              @points[val + right_cell] << [x - 1, y, outside]
            end
          end

          down_cell = @grid[x, y + 1]
          double_down_cell = @grid[x, y + 2]
          up_cell = @grid[x, y - 1]
          if down_cell && down_cell.match(/^[A-Z]$/) && (double_down_cell == '.' || up_cell == '.')
            @points[val + down_cell] ||= []

            if double_down_cell == '.'
              @points[val + down_cell] << [x, y + 2, outside]
            end
            if up_cell == '.'
              @points[val + down_cell] << [x, y - 1, outside]
            end
          end

        end
      end

      @points.values.each do |vals|
        if vals.length == 2
          a, w = vals
          b, c, _ = a
          x, y, _ = w
          @points[[x, y]] = a
          @points[[b, c]] = w
        end
      end

      @points['AA'][0][2] = 0
      @points['ZZ'][0][2] = 0

      @points
    end

    def start_pos
      @points['AA'].first
    end

    def end_pos
      @points['ZZ'].first
    end

    def debug!
      @debug = true
    end

    def steps
      paths = [[start_pos]]
      visited = Set.new([start_pos])
      j = 0
      while j < paths.length && j < 10_000 do
        path_group = paths[j]
        puts "Dist: #{j}, Paths: #{path_group}, Visited: #{visited}" if @debug
        path_group.each do |pos|
          neighbors = grid.neighbors(pos)
          level_lookup = points[pos.first(2)]
          neighbors[level_lookup] = '.' if level_lookup
          puts "\tPos: #{pos} #{neighbors}" if @debug
          # binding.pry if @debug && pos == [9,6,0]
          neighbors.each do |n_cell, n_val|
            next if n_val != '.'

            level = pos[2]
            level += n_cell[2] if n_cell[2]
            next if level < 0
            n_cell = [n_cell[0], n_cell[1], level]
            puts "\t\tLevel Change: #{n_cell}" if pos[2] && n_cell[2] && pos[2] != level && @debug
            # next if negative level

            next if visited.include? n_cell

            visited.add n_cell
            return j+1 if n_cell == end_pos

            paths[j+1] ||= []
            paths[j+1] << n_cell
          end
        end
        j += 1
      end

      raise "Unable to find end of path"
    end
  end
end
