require 'set'
require '../lib/grid.rb'

module Advent

  class Maze
    attr_accessor :debug
    attr_reader :grid, :magic

    def initialize(input)
      @debug = false
      @grid = Grid.new
      @magic = input.to_i
    end

    def debug!
      @debug = true
    end

    STARTING_POS = [1,1]

    def wall?(pos)
      return @grid[pos] if @grid.cells.has_key?(pos)
      x, y = pos
      num = x*x + 3*x + 2*x*y + y + y*y + @magic
      count = 0
      until num == 0 do
        count += 1 if (num & 1) == 1
        num = num >> 1
      end
      @grid[pos] = count.odd?
    end

    def steps(target, max_steps = 100)
      steps = 0
      visited = Set.new([STARTING_POS])
      return steps if target == STARTING_POS

      positions = [STARTING_POS]

      while steps < max_steps do
        steps += 1
        next_positions = []
        positions.each do |pos|
          Grid::CARDINAL_DIRECTIONS.each do |dir|
            x, y = pos
            x_delta, y_delta = dir
            new_pos = [x + x_delta, y + y_delta]
            next if new_pos[0] < 0 || new_pos[1] < 0
            return steps if new_pos == target
            # puts "Wall: #{new_pos} #{wall?(new_pos)}" if @debug
            next if wall?(new_pos)
            next if visited.include? new_pos
            visited.add new_pos
            next_positions << new_pos
          end
        end
        puts "Steps: #{steps} Positions: #{positions.length} Visited: #{visited.count}" if @debug
        positions = next_positions
      end
      visited.count
    end
  end
end
