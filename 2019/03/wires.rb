require 'set'

module Advent

  class Wires
    attr_reader :grid, :instructions
    attr_accessor :debug

    DIRECTION = {
      'R' => [1,0],
      'U' => [0,1],
      'L' => [-1,0],
      'D' => [0,-1],
    }

    def initialize(input)
      @grid = Grid.new
      @instructions = input.each_line.map { |l| l.chomp.split(",") }
      @debug = false
    end

    def parse!(instructions, val)
      @grid.pos = [0,0]
      instructions.each do |inst|
        if inst =~ /(\w)(\d+)/
          direction = DIRECTION[$1]
          distance = $2.to_i
          @grid.draw!(direction, distance, val, :|)
          puts "#{inst} - Dir: #{direction}, Distance: #{distance}, #{@grid.cells}" if @debug
        end
      end
    end

    def intersections
      return @intersections if @intersections
      @instructions.each_with_index do |inst, i|
        parse!(inst, 2 ** i)
      end
      @intersections = @grid.cells.select do |cell, val|
        val == 3
      end.keys
    end

    def distance_intersection
      puts "Intersections: #{intersections}" if @debug
      intersections.map do |int|
        int[0].abs + int[1].abs
      end.min
    end
  end
end

class Grid
  attr_accessor :cells, :pos

  X = 0
  Y = 1

  def initialize
    @cells = {}
    @pos = [0,0]
  end

  def draw!(direction, distance, val = true, operator = nil)
    x, y = direction
    distance.times do |i|
      new_pos = [@pos[X] + x, @pos[Y] + y]
      if @cells[new_pos].nil?
        @cells[new_pos] = val
      else
        if operator
          @cells[new_pos] = @cells[new_pos].__send__(operator, val)
        else
          @cells[new_pos] = val
        end
      end
      @pos = new_pos
    end
  end
end
