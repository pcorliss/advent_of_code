require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Police
    attr_accessor :debug
    attr_reader :grid, :direction, :program

    def initialize(input)
      @debug = false
      @direction = 0
      @grid = Grid.new
      @program = IntCode.new(input)
    end

    def debug!
      @debug = true
    end

    # Input
    # provide 0 if the robot is over a black panel or 1 if the robot is over a white panel.
    #
    # First, it will output a value indicating the color to paint the panel the robot is over: 0 means to paint the panel black, and 1 means to paint the panel white.
    # Second, it will output a value indicating the direction the robot should turn: 0 means it should turn left 90 degrees, and 1 means it should turn right 90 degrees.

    def run!
      i = 0
      until @program.halted? do
        begin
        inp = @grid.cells[@grid.pos] || 0
        puts "Input: #{inp}" if @debug
        @program.program_input = inp
        @program.run!

        puts "Outputs: #{@program.full_output}" if @debug
        color = @program.output
        puts "Color: #{color}" if @debug
        @grid.cells[@grid.pos] = color

        turn = @program.output
        puts "Turn: #{turn}" if @debug
        @direction += TURNS[turn]
        @direction %= 360
        x_delta, y_delta = DIRECTION[@direction]
        @grid.pos = [@grid.pos[0] + x_delta, @grid.pos[1] + y_delta]
        puts "Pos: #{@grid.pos} Direction: #{@direction}" if @debug
        puts "Grid:\n#{@grid.render}" if @debug
        i += 1
        raise "Too Many Iterations!!!" if i > 30000
        rescue => e
          # puts "E: #{e}"
          # require 'pry'
          # binding.pry if @debug
          raise e
        end
      end
    end

    COLORS={
      black: 0,
      white: 1,
    }
    TURNS=[
      -90,
      90,
    ]
    DIRECTION={
      0   => [ 0, 1],
      90  => [ 1, 0],
      180 => [ 0,-1],
      270 => [-1, 0],
    }

  end
end
