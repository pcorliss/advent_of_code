require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Path
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @grid.cells.each do |cell, val|
        if val =~ /\s/
          @grid.cells.delete(cell)
        end
      end
    end

    def debug!
      @debug = true
    end

    def start
      @grid.cells.each do |cell, val|
        _, y = cell
        return cell if val == '|' && y == 0
      end
      nil
    end

    def follow
      acc = []
      pos = start
      dir = [0, 1]
      i = 0
      loop do
        new_pos = [pos[0] + dir[0], pos[1] + dir[1]] 
        val = @grid[new_pos]
        # raise "Bad Value for #{val} #{new_pos}" if val.nil?
        return acc if val.nil?
        if val == '+'
          cell, _ = @grid.neighbors(new_pos).find do |cell, val|
            cell != pos
          end
          dir = [cell[0] - new_pos[0], cell[1] - new_pos[1]]
        end
        if val =~ /[A-Z]/
          acc << val
        end
        pos = new_pos
        i += 1
        raise "Too many iterations!!! #{i}" if i > 100000
      end
      acc
    end
  end
end
