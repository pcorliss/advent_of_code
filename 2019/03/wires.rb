require 'set'

module Advent

  class Wires
    attr_reader :grid, :instructions, :trace
    attr_accessor :debug

    DIRECTION = {
      'R' => [1,0],
      'U' => [0,1],
      'L' => [-1,0],
      'D' => [0,-1],
    }

    def initialize(input)
      @grid = Grid.new
      @trace = Grid.new
      @instructions = input.each_line.map { |l| l.chomp.split(",") }
      @debug = false
    end

    def parse!(instructions, val)
      @grid.pos = [0,0]
      @trace.pos = [0,0]
      t = 0
      instructions.each do |inst|
        if inst =~ /(\w)(\d+)/
          direction = DIRECTION[$1]
          distance = $2.to_i
          @grid.draw!(direction, distance, val, :|)
          t = @trace.trace!(direction, distance, t)
          puts "#{inst} - #{t} #{@trace.cells}" if @debug
          # puts "#{inst} - Dir: #{direction}, Distance: #{distance}, #{@trace.cells}, #{@grid.cells}" if @debug
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

    def shortest_intersection
      intersections.map do |int|
        @trace.cells[int]
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

  def trace!(direction, distance, val)
    x, y = direction
    counter = val
    distance.times do |i|
      counter = val + i + 1
      new_pos = [@pos[X] + x, @pos[Y] + y]
      @cells[new_pos] ||= 0
      @cells[new_pos] += counter
      @pos = new_pos
    end
    counter
  end
end
