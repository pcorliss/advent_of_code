require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Flare
    attr_accessor :debug
    attr_reader :program, :grid

    def initialize(input)
      @debug = false
      @program = Advent::IntCode.new(input)
      @grid = Grid.new
    end

    def fill_grid!
      @program.run!
      output = @program.full_output
      width = output.index("\n".ord)
      output.delete("\n".ord)
      @grid = Grid.new(output.map(&:chr), width)
    end

    def intersections
      inter = []
      @grid.cells.each do |cell, val|
        if val == '#' && @grid.neighbors(cell).all? { |ncell, nval| nval == '#' }
          inter << cell
        end
      end
      inter
    end

    def debug!
      @debug = true
    end
  end
end
