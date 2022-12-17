require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Tetris
    attr_accessor :debug
    attr_reader :jets, :jet_pos, :rock_pos, :grid

    ROCKS = [
      [[0,0],[1,0],[2,0],[3,0]],        #.####

      [[1,0],[0,1],[1,1],[2,1],[1,2]],  # .#.
                                        # ###
                                        # .#.

      [[2,0],[2,1],[0,2],[1,2],[2,2]],  # ..#
                                        # ..#
                                        # ###

      [[0,0],[0,1],[0,2],[0,3]],        # #
                                        # #
                                        # #
                                        # #

      [[0,0],[1,0],[0,1],[1,1]],        # ##
                                        # ##
    ]
    def initialize(input)
      @debug = false
      @jets = input.strip.chars.map(&:to_sym)
      @jet_pos = 0
      @rock_pos = 0
      @grid = Grid.new
    end

    def debug!
      @debug = true
    end

    def get_next_jet
      j = @jets[@jet_pos]
      @jet_pos += 1
      @jet_pos %= @jets.count
      j
    end

    def get_next_rock
      r = ROCKS.first
      @rock_pos += 1
      @rock_pos %= ROCKS.count
      r
    end
  end
end
