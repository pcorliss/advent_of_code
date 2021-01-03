require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Oxygen
    attr_accessor :debug
    attr_reader :grid, :program, :paths, :sensor, :sensor_found_in, :iter

    def initialize(input)
      @debug = false
      @program = Advent::IntCode.new(input)
      @grid = Grid.new
      @grid.cells[[0,0]] = ' '
    end

    # north (1), south (2), west (3), and east (4)
    # '#' == "Wall"
    # ' ' == 'Open'
    # 'D' == 'Sensor'
    #
    # 0: The repair droid hit a wall. Its position has not changed.
    # 1: The repair droid has moved one step in the requested direction.
    # 2: The repair droid has moved one step in the requested direction; its new position is the location of the oxygen system.

    # can do a breadth first search for the oxygen sensor, but that's a lot of paths
    #   can prune if you hit a wall because that's gauranteed to be the non-optimal path
    #   can prune if you travel ground that's already been hit
    #   share the discovered grid between iterations for caching purposes and presumably a part two?
    #   Could clone the intcode program, but need to do a deepclone otherwise the array won't work properly
    #   Arrays will need a deepclone, everything else should work fine
    # can just map the system in full and then find it via the grid
    #   but how would we use the grid to find the optimal path?

    # Accept a movement command via an input instruction.
    # Send the movement command to the repair droid.
    # Wait for the repair droid to finish the movement operation.
    # Report on the status of the repair droid via an output instruction.
  
    # The grid by default uses an inverted y-axis
    DIRECTIONS = {
      1 => [ 0,-1], # North
      2 => [ 0, 1], # South
      3 => [-1, 0], # West
      4 => [ 1, 0], # East
    }

    # '#' == "Wall"
    # ' ' == 'Open'
    # 'D' == 'Sensor'
    #
    # 0: The repair droid hit a wall. Its position has not changed.
    # 1: The repair droid has moved one step in the requested direction.
    # 2: The repair droid has moved one step in the requested direction; its new position is the location of the oxygen system.
    #
    OUT_MAP = {
      0 => '#',
      1 => ' ',
      2 => 'D',
    }

    def move!
      @paths ||= [{
        program: program,
        pos: [0, 0]
      }]
      return if @paths.empty?

      @iter ||= 0
      @iter += 1

      new_paths = []
      @paths.each_with_index do |path, idx|
        start_pos = path[:pos]
        DIRECTIONS.each do |dir, delta|
          pos = start_pos.clone
          new_pos = [pos[0] + delta[0], pos[1] + delta[1]]
          # TODO: Add some cell access helper methods
          next if @grid.cells[new_pos]
          program = path[:program].deepclone
          program.program_input = dir
          program.run!
          out = program.output
          if out == 2
            @sensor = new_pos
            @sensor_found_in = @iter
          end
          cell_val = OUT_MAP[out]
          @grid.cells[new_pos] = cell_val
          if out != 0
            pos = new_pos
            new_paths << {
              program: program,
              pos: pos,
            }
          end
        end
      end

      @paths = new_paths
    end

    def grid_filled?
      @paths && @paths.empty?
    end

    def debug!
      @debug = true
    end
  end
end
