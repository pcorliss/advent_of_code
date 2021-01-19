require 'set'
require '../lib/grid.rb'

module Advent

  class Sphere
    attr_accessor :debug
    attr_reader :directions, :grid, :robo_grid

    def initialize(input)
      @debug = false
      @directions = input.chomp.chars
      @grid = Grid.new
      @robo_grid = Grid.new
    end

    def debug!
      @debug = true
    end


    DIRECTIONS = Hash['<>^v'.chars.zip(Grid::CARDINAL_DIRECTIONS)]

    def trace!
      @grid[0,0] = 1
      @directions.each do |dir|
        @grid.draw!(DIRECTIONS[dir], 1, 1, :+)
      end
    end

    def dupes
      @grid.cells.select {|k, v| v > 1}.keys
    end

    def robo_trace!
      @grid[0,0] = 1
      @robo_grid[0,0] = 1
      i = 0
      @directions.each do |dir|
        g = i.even? ? @grid : @robo_grid
        g.draw!(DIRECTIONS[dir], 1, 1, :+)
        i += 1
      end
    end

    def robo_houses
      robo_trace!
      (@grid.cells.keys | @robo_grid.cells.keys).count
    end
  end
end
