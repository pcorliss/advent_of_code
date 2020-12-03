require 'set'

module Advent
  TREE = '#'
  OPEN = '.'

  class Three
    attr_reader :input, :width, :height, :pos, :trees

    # Travel direction
    RIGHT=3
    DOWN=1

    def initialize(input)
      @pos = [0, 0]
      @input = input.lines.map { |l| l.chomp.chars }
      @height = @input.count
      @width = @input.first.count
      @trees = 0
      @trees += 1 if tree?
    end

    def step!
      return if bottom?
      @pos = [
        @pos[0] + RIGHT,
        @pos[1] + DOWN,
      ]

      @trees += 1 if tree?
    end

    def tree?
      # first index is y, then x
      @input[@pos[1]][@pos[0] % @width] == TREE
    end

    def bottom?
      @pos[1] >= @height - 1
    end

    def go_to_bottom!
      while bottom? == false
        step!
      end
    end
  end
end
