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

  class RecursiveBugs
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = RecursiveGrid.new(input)
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

          # A bug dies (becoming an empty space) unless there is exactly one bug adjacent to it.
          new_grid.cells[cell] = '.'
          new_grid.cells[cell] = '#' if bug_count == 1
        end
      end

      adjacent.each do |cell, v|
        # An empty space becomes infested with a bug if exactly one or two bugs are adjacent to it.
        if (v == 1 || v == 2) && (@grid.cells[cell] != '#')
          new_grid.cells[cell] = '#'
        end
      end

      binding.pry if @debug
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

  class RecursiveGrid < Grid

    TRANSLATIONS = {
      [-1,0] => [1,2,-1],
      [-1,1] => [1,2,-1],
      [-1,2] => [1,2,-1],
      [-1,3] => [1,2,-1],
      [-1,4] => [1,2,-1],

      [5,0] => [3,2,-1],
      [5,1] => [3,2,-1],
      [5,2] => [3,2,-1],
      [5,3] => [3,2,-1],
      [5,4] => [3,2,-1],

      [0,-1] => [2,1,-1],
      [1,-1] => [2,1,-1],
      [2,-1] => [2,1,-1],
      [3,-1] => [2,1,-1],
      [4,-1] => [2,1,-1],

      [0,5] => [2,3,-1],
      [1,5] => [2,3,-1],
      [2,5] => [2,3,-1],
      [3,5] => [2,3,-1],
      [4,5] => [2,3,-1],
    }

    CARDINAL_INNER_MAP = {
      [ 0,-1] => [
        [0,4,1],
        [1,4,1],
        [2,4,1],
        [3,4,1],
        [4,4,1],
      ],
      [ 0, 1] => [
        [0,0,1],
        [1,0,1],
        [2,0,1],
        [3,0,1],
        [4,0,1],
      ],
      [ -1, 0] => [
        [4,0,1],
        [4,1,1],
        [4,2,1],
        [4,3,1],
        [4,4,1],
      ],
      [ 1, 0] => [
        [0,0,1],
        [0,1,1],
        [0,2,1],
        [0,3,1],
        [0,4,1],
      ],
    }

    Z = 2

    def neighbors(cell)
      transformed = []
      CARDINAL_DIRECTIONS.each do |dir|
        x = cell[X] + dir[X]
        y = cell[Y] + dir[Y]
        new_cell = [x,y]
        # puts "TRANSLATION: #{dir} #{new_cell} #{TRANSLATIONS[new_cell]}"
        new_cell = TRANSLATIONS[new_cell] if TRANSLATIONS[new_cell]
        if new_cell == [2,2]
          transformed.concat CARDINAL_INNER_MAP[dir] if new_cell == [2,2]
        else
          transformed << new_cell 
        end
      end
      # puts "Transformed: #{transformed}"
      #@cells.slice(*transformed)
      z_level = cell[Z] || 0
      transformed.inject({}) do |acc, t_cell|
        # puts "Cell: #{cell}"
        x, y, z = t_cell
        z ||= 0
        new_cell = [x, y, z + z_level]
        new_cell = [x, y] if new_cell[Z] == 0
        acc[new_cell] = @cells[new_cell] || '.'
        acc
      end
    end
  end
end
