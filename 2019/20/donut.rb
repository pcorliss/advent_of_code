require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Donut
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
      @grid.cells.each do |cell, val|
        if val.match(/^[A-Z]$/)
          x, y = cell

          right_cell = @grid[x + 1, y]
          double_right_cell = @grid[x + 2, y]
          left_cell = @grid[x - 1, y]
          if right_cell && right_cell.match(/^[A-Z]$/) && (double_right_cell == '.' || left_cell == '.')
            @points[val + right_cell] ||= []
            @points[val + right_cell] << [x + 2, y] if double_right_cell == '.'
            @points[val + right_cell] << [x - 1, y] if left_cell == '.'
          end

          down_cell = @grid[x, y + 1]
          double_down_cell = @grid[x, y + 2]
          up_cell = @grid[x, y - 1]
          if down_cell && down_cell.match(/^[A-Z]$/) && (double_down_cell == '.' || up_cell == '.')
            @points[val + down_cell] ||= []
            @points[val + down_cell] << [x, y + 2] if double_down_cell == '.'
            @points[val + down_cell] << [x, y - 1] if up_cell == '.'
          end
        end
      end

      @points.values.each do |vals|
        if vals.length == 2
          a, b = vals
          @points[a] = b
          @points[b] = a
        end
      end

      @points
    end

    def start_pos
      map_points! unless @points
      @points['AA'].first
    end

    def end_pos
      map_points! unless @points
      @points['ZZ'].first
    end

    def debug!
      @debug = true
    end

    def steps
      paths = [[start_pos]]
      visited = Set.new([start_pos])
      j = 0
      while j < paths.length && j < 1000 do
        path_group = paths[j]
        puts "Dist: #{j}, Paths: #{path_group}, Visited: #{visited}" if @debug
        path_group.each do |pos|
          puts "Pos: #{pos} #{grid.neighbors(pos)}" if @debug
          neighbors = grid.neighbors(pos)
          neighbors[@points[pos]] = '.' if @points[pos]
          neighbors.each do |n_cell, n_val|
            next if n_val != '.'
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
