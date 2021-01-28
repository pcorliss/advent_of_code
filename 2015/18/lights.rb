require 'set'
require '../lib/grid.rb'

module Advent

  class Lights
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
    end

    def debug!
      @debug = true
    end

    def step!
      neighbor_count = {}
      @grid.cells.each do |pos, cell|
        next if cell == '.'
        @grid.neighbors(pos, true).each do |n_pos, n_cell|
          neighbor_count[n_pos] ||= 0
          neighbor_count[n_pos] += 1
        end
      end

      new_grid = Grid.new()
      @grid.cells.each do |pos, cell|
        new_grid[pos] = cell
        if cell == '#'
          new_grid[pos] = '.'
          new_grid[pos] = '#' if neighbor_count[pos] == 2 || neighbor_count[pos] == 3
        else
          new_grid[pos] = '.'
          new_grid[pos] = '#' if neighbor_count[pos] == 3
        end
      end

      @grid = new_grid
    end

    def corners_on!
      @w ||= @grid.width - 1
      @grid[0,@w] = '#'
      @grid[@w,@w] = '#'
      @grid[@w,0] = '#'
      @grid[0,0] = '#'
    end
  end
end
