require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Bugs
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @seen = Set.new
    end

    def debug!
      @debug = true
    end

    def step!
      new_grid = @grid.clone
      new_grid.cells = new_grid.cells.clone
      @seen.add new_grid.cells.clone

      adjacent = {}
      @grid.cells.each do |cell, v|
        if v == '#'
          bug_count = 0
          @grid.neighbors(cell).each do |n_cell, n_val|
            adjacent[n_cell] ||= 0
            adjacent[n_cell] += 1

            bug_count += 1 if n_val == '#'
          end

          new_grid[cell] = '.'
          new_grid[cell] = '#' if bug_count == 1
        end
      end

      adjacent.each do |cell, v|
        if (v == 1 || v == 2) && (@grid[cell] != '#')
          new_grid[cell] = '#'
        end
      end

      @grid = new_grid
    end

    def repeat?
      @seen.include? @grid.cells
    end

    def biodiversity_rating
      acc = 0
      i = 0
      (0..@grid.width-1).each do |y|
        (0..@grid.width-1).each do |x|
          # puts "Cell: #{x},#{y} #{@grid[x,y]} #{i} #{2**i} #{acc}"
          acc += 2**i if @grid[x,y] == '#'
          i += 1
        end
      end
      acc
    end
  end
end
