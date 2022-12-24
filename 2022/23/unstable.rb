require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require 'deep_clone'

module Advent

  class Unstable
    attr_accessor :debug
    attr_reader :grid, :dir_idx

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @grid.cells = @grid.cells.delete_if { |k,v| v == '.' }
      @dir_idx = 0
    end

    def debug!
      @debug = true
    end

    DIRECTIONS = [
      [
        [ 0,-1], # North
        [-1,-1], # NorthWest
        [ 1,-1], # NorthEast
      ],
      [
        [ 0, 1], # South
        [-1, 1], # SouthWest
        [ 1, 1], # SouthEast
      ],
      [
        [-1, 0], # West
        [-1, 1], # SouthWest
        [-1,-1], # NorthWest
      ],
      [
        [ 1, 0], # East
        [ 1, 1], # SouthEast
        [ 1,-1], # NorthEast
      ],
    ]

    def step!
      proposed = Grid.new
      @grid.cells.each do |cell, val|
        x, y = cell
        puts "Cell: #{cell} #{val}" if @debug && cell == [0,2]
        next if @grid.neighbors(cell, true).empty?
        puts "Has Neighbors" if @debug && cell == [0,2]
        possibility = nil
        4.times do |i|
          dirs = DIRECTIONS[(i + @dir_idx) % DIRECTIONS.length]
          all = dirs.all? do |dir|
            delta_x, delta_y = dir
            @grid[x + delta_x, y + delta_y].nil?
          end
          if all
            possibility = dirs
            break
          end
        end
        puts "Possibility: #{possibility}" if @debug && cell == [0,2]
        if possibility
          delta_x, delta_y = possibility.first
          proposed[x + delta_x, y + delta_y] ||= []
          proposed[x + delta_x, y + delta_y] << [x,y]
        end
      end

      new_grid = DeepClone.clone @grid
      proposed.cells.each do |cell, proposed|
        next if proposed.count > 1
        
        new_grid.cells[cell] = new_grid.cells[proposed.first]
        new_grid.cells.delete proposed.first
      end
      @dir_idx += 1
      @grid = new_grid
    end

    def empty_ground
      @grid.render.each_char.count do |char|
        char == ' '
      end
    end

    def final_round
      i = 0
      while true do
        previous = @grid
        step!
        i += 1
        break if previous.cells == @grid.cells
        raise "Too many iterations" if i > 10000
      end
      i
    end
  end
end
