require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Treehouse
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
    end

    def debug!
      @debug = true
    end

    def visible_dir(cell, direction)
      height = @grid.cells[cell]
      x, y = cell
      delta_x, delta_y = direction
      x -= delta_x
      y -= delta_y
      until x < 0 || y < 0 || x >= @grid.width || y >= @grid.height do
        return false if @grid.cells[[x, y]] >= height
        x -= delta_x
        y -= delta_y
      end
      true
    end

    def visible(cell)
      height = @grid.cells[cell]
      cell_x, cell_y = cell
      Grid::CARDINAL_DIRECTIONS.any? do |dir|
        visible_dir(cell, dir)
      end
    end

    def count_visible
      @grid.cells.select do |cell|
        visible(cell)
      end.count
    end
  end
end
