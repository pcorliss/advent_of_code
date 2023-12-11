require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Cosmic
    attr_accessor :debug
    attr_reader :grid, :galaxy_expanded

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @galaxy_expanded = false
    end

    def debug!
      @debug = true
    end

    def expand_galaxy!(factor = 1)
      return if @galaxy_expanded
      new_grid = Grid.new
      grid_row_count = Array.new(@grid.height, 0)
      grid_col_count = Array.new(@grid.width, 0)
      @galaxies = Set.new
      @grid.cells.each do |cell, val|
        if val == '#'
          x, y = cell
          grid_row_count[y] += 1
          grid_col_count[x] += 1
          @galaxies << [x,y]
        end
      end

      new_galaxies = Set.new
      @galaxies.each do |x, y|
        y_offset = grid_row_count[0..y].count(0)
        x_offset = grid_col_count[0..x].count(0)
        new_pos = [x + x_offset * factor, y + y_offset * factor]
        new_grid[new_pos] = '#'
        new_galaxies << new_pos
      end

      @galaxies = new_galaxies
      puts "Galaxies: #{@galaxies}" if @debug
      @grid = new_grid
      @galaxy_expanded = true
    end

    def shortest_path(x1, y1, x2, y2)
      (x1 - x2).abs + (y1 - y2).abs
    end

    def shortest_path_sum
      expand_galaxy!
      @galaxies.to_a.combination(2).sum do |(x, y), (x2, y2)|
        shortest_path(x, y, x2, y2)
      end
    end
  end
end
