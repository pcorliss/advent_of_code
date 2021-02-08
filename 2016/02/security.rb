require 'set'
require '../lib/grid.rb'

module Advent

  class Security
    attr_accessor :debug
    attr_reader :inst, :keypad

    def initialize(input)
      @debug = false
      @inst = input.each_line.map do |line|
        line.chomp!
        line.chars.to_a
      end
      @keypad = Grid.new((1..9), 3)
    end

    def debug!
      @debug = true
    end

    INST_MAP = {
      'U' => [ 0,-1],
      'D' => [ 0, 1],
      'L' => [-1, 0],
      'R' => [ 1, 0],
    }
    X = 0
    Y = 1

    def run_inst(start, instructions)
      new_pos = start.clone
      instructions.each do |instruction|
        x_delta, y_delta = INST_MAP[instruction]
        new_x = new_pos[X] + x_delta
        new_y = new_pos[Y] + y_delta
        new_pos = [new_x, new_y] if new_x >= 0 && new_y >= 0 && new_x < 3 && new_y < 3
      end
      new_pos
    end

    def run_all_instructions(start)
      pos = start.clone
      @inst.map do |instruction|
        pos = run_inst(pos, instruction)
      end
    end

    def map_code(positions)
      positions.map do |pos|
        @keypad.get(pos)
      end
    end
  end
end
