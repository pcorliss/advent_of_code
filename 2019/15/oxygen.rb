require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Oxygen
    attr_accessor :debug

    def initialize(input)
      @debug = false
    end

    # north (1), south (2), west (3), and east (4)
    #
    # 0: The repair droid hit a wall. Its position has not changed.
    # 1: The repair droid has moved one step in the requested direction.
    # 2: The repair droid has moved one step in the requested direction; its new position is the location of the oxygen system.

    # can do a breadth first search for the oxygen sensor, but that's a lot of paths
    #   can prune if you hit a wall because that's gauranteed to be the non-optimal path
    #   share the discovered grid between iterations for caching purposes and presumably a part two?
    #   Could clone the intcode program, but need to do a deepclone otherwise the array won't work properly
    #   Arrays will need a deepclone, everything else should work fine
    # can just map the system in full and then find it via the grid
    #   but how would we use the grid to find the optimal path?

    

    def debug!
      @debug = true
    end
  end
end
