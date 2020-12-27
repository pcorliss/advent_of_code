require 'set'

module Advent

  class Wires
    def initialize(input)
    end
  end
end

class Grid
  attr_reader :cells, :pos

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
