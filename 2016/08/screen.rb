require 'set'
require '../lib/grid.rb'

module Advent

  class Screen
    attr_accessor :debug
    attr_reader :instructions, :grid

    def initialize(input, width, height)
      @debug = false
      @instructions = input.each_line.map(&:chomp)
      @grid = Grid.new([], width, height)
    end

    def debug!
      @debug = true
    end

    def interpret_instruction(inst)
      acc = []
      if inst.start_with? 'rect'
        acc << :rect
        if inst =~ /^rect (\d+)x(\d+)$/
          acc << $1.to_i
          acc << $2.to_i
        end
      elsif inst.start_with? 'rotate'
        acc << :rotate
        if inst =~ /^rotate \w+ ([xy])=(\d+) by (\d+)$/
          acc << $1.to_sym
          acc << $2.to_i
          acc << $3.to_i
        end
      end
      acc
    end

    def pos(x_or_y, a, b)
      x_or_y == :x ? [a, b] : [b, a]
    end

    def apply!(inst)
      cmd, *args = interpret_instruction(inst)
      case cmd
      when :rect
        x, y = args
        x.times.each do |i|
          y.times.each do |j|
            @grid[i,j] = 1
          end
        end
      when :rotate
        x_or_y, offset, delta = args
        new_vals = []
        length = x_or_y == :x ? @grid.height : @grid.width
        length.times do |j|
          new_vals[(j + delta) % length] = @grid[*pos(x_or_y, offset, j)]
        end
        new_vals.each_with_index do |val, j|
          @grid[*pos(x_or_y, offset, j)] = val
        end
      end
    end
  end
end
