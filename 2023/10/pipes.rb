require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Pipes
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
    end

    def debug!
      @debug = true
    end

    def starting_point
      c, _ = @grid.cells.find do |cell, val|
        val == 'S'
      end

      c
    end

    PIPE_MAP = {
      '-' => [[-1, 0],[ 1, 0]],
      '|' => [[ 0,-1],[ 0, 1]],
      'L' => [[ 1, 0],[ 0,-1]],
      'F' => [[ 1, 0],[ 0, 1]],
      'J' => [[-1, 0],[ 0,-1]],
      '7' => [[-1, 0],[ 0, 1]],
    }

    def starting_directions
      dirs = []
      start = starting_point
      puts "Start: #{start}" if @debug
      @grid.neighbors(start).each do |pos, val|
        puts "Pos: #{pos}, Val: #{val}}" if @debug
        next if val == '.' || val.nil? || PIPE_MAP[val].nil?
        PIPE_MAP[val].each do |dir_x, dir_y|
          pos_x, pos_y = pos
          d_x = pos_x + dir_x
          d_y = pos_y + dir_y
          dirs << [-dir_x, -dir_y] if [d_x, d_y] == start
        end
      end
      dirs
    end

    def first_steps
      start = starting_point
      starting_directions.map do |dir_x, dir_y|
        pos_x, pos_y = start
        d_x = pos_x + dir_x
        d_y = pos_y + dir_y
        [d_x, d_y]
      end
    end

    # Because it's a loop with only one entrance/exit,
    # we can walk both directions until we hit a spot that has been visited
    def walk
      start = starting_point
      steps = 0
      visited = {starting_point => 0}
      positions = first_steps

      until positions.empty? do
        steps += 1
        raise "Too many steps!" if steps > 10_000
        new_positions = []
        positions.each do |pos|
          pos_x, pos_y = pos
          visited[pos] = steps
          val = @grid[pos]
          raise "Unexpected #{val} val found for position #{pos}" if val == '.' || val.nil? || PIPE_MAP[val].nil?
          PIPE_MAP[val].each do |dir_x, dir_y|
            new_pos = [pos_x + dir_x, pos_y + dir_y]
            next if visited.has_key? new_pos
            new_positions << new_pos
          end
        end
        positions = new_positions
      end
     
      steps
    end
  end
end
