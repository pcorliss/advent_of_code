require 'set'

module Advent

  class Image
    attr_accessor :debug
    attr_reader :layers

    def initialize(input, width, height)
      @debug = false
      area = width * height
      @layers = (input.length / area).times.map do |idx|
        range = ((idx * area)..((idx + 1) * area - 1))
        Grid.new(input.slice(range).chars.map(&:to_i), width)
      end
    end

    def debug!
      @debug = true
    end

    def compose_layers
      g = Grid.new
      g.width = @layers.first.width

      @layers.first.cells.each do |cell, x|
        l = @layers.find do |layer|
          layer.cells[cell] != 2
        end
        g.cells[cell] = l.cells[cell]
      end

      g
    end
  end
end

class Grid
  attr_accessor :width
  attr_accessor :cells, :pos

  X = 0
  Y = 1

  def initialize(init = nil, width = nil)
    @debug = false
    @cells = {}
    @pos = [0,0]
    if init && width
      @width = width
      init.each_with_index do |val, idx|
        x = idx % width
        y = idx / width
        @cells[[x, y]] = val
      end
    end
  end

  def debug!
    @debug = true
  end

  def render
    min_y, max_y = @cells.keys.map(&:last).minmax
    min_x, max_x = @cells.keys.map(&:first).minmax

    puts "Grid: #{@cells}" if @debug
    puts "Cells: #{@cells.keys}" if @debug
    puts "[#{min_x},#{min_y}] -> [#{max_x},#{max_y}]" if @debug
    acc = ""
    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        cell = @cells[[x,y]] || ' '
        acc << cell.to_s
      end
      acc << "\n"
    end
    acc.chomp!
    acc
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
