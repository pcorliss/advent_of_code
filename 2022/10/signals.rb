require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Signals
    attr_accessor :debug
    attr_reader :instructions, :x, :cycle
    attr_reader :instruction_counter, :instruction_position
    attr_reader :grid

    def initialize(input)
      @debug = false
      @instructions = input.each_line.map do |line|
        action, quant = line.split(' ')
        inst = [action.to_sym]
        inst << quant.to_i if quant
        inst
      end
      @x = 1
      @cycle = 0
      @instruction_counter = 0
      @instruction_position = 0

      @grid = Grid.new(('.'*240).chars, 40)
    end

    def debug!
      @debug = true
    end

    def draw_pixel
      cell_x = cycle % grid.width
      cell_y = cycle / grid.width
      # if sprite present
      # sprite is 3px wide and centered on X
      @grid[cell_x,cell_y] = '#' if cell_x.between? x-1, x+1
    end

    def run_cycle!
      draw_pixel

      instruction, quant = instructions[instruction_position]
      # puts "Start of #{cycle + 1} cycle, X: #{x}, #{instruction} Part: #{instruction_counter}" if debug
      case instruction
      when :addx
        if instruction_counter >= 1
          @instruction_counter = 0
          @instruction_position += 1
          @x += quant
        else
          @instruction_counter += 1
        end
      when :noop
        @instruction_position += 1
      else
        raise "Out of instructions!"
      end
      @cycle += 1
      # puts "End   of #{cycle} cycle, X: #{x}, #{instruction} Part: #{instruction_counter}" if debug
    end

    def signal_strength
      (cycle + 1) * x
    end

    INTERESTING = [20, 60, 100, 140, 180, 220]
    def interesting_signals
      INTERESTING.map do |test_cycle|
        until (cycle + 1) == test_cycle do
          run_cycle!
        end
        puts "Cycle: #{cycle} #{signal_strength}" if debug
        signal_strength
      end
    end

    def render
      240.times { run_cycle! }
      grid.render
    end
  end
end
