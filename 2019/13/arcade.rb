require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Arcade
    attr_accessor :debug
    attr_reader :grid, :program

    def initialize(input)
      @debug = false
      @program = IntCode.new(input)
      @grid = Grid.new
    end

    def debug!
      @debug = true
    end

    def run!
      @program.run!
      if @program.outputs
        cell_count = @program.outputs.count / 3
        cell_count.times do |i|
          x = @program.output
          y = @program.output
          val = @program.output
          @grid.cells[[x,y]] = val
        end

        ball = @grid.cells.find do |cell, val|
          val == 4
        end.first

        paddle = @grid.cells.find do |cell, val|
          val == 3
        end.first

        if ball[0] < paddle[0]
          @program.program_input = -1
        elsif ball[0] > paddle[0]
          @program.program_input = 1
        else
          @program.program_input = 0
        end
      end
    end

    # 0 is an empty tile. No game object appears in this tile.
    # 1 is a wall tile. Walls are indestructible barriers.
    # 2 is a block tile. Blocks can be broken by the ball.
    # 3 is a horizontal paddle tile. The paddle is indestructible.
    # 4 is a ball tile. The ball moves diagonally and bounces off objects.
    TILES = ['01234', ' XW=O']
    # TILES = ['01234', ' 🟥🟦🟧⚽']
  end
end
