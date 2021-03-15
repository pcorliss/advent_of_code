require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Fractal
    attr_accessor :debug
    attr_reader :rules

    STARTING_PATTERN = <<~EOS
    .#.
    ..#
    ###
    EOS

    def initialize(input)
      @debug = false
      @rules = {}
      i = 0
      input.each_line do |line|
        line.chomp!
        a, b = line.split(' => ')
        a.gsub!('/', "\n")
        b.gsub!('/', "\n")

        g = Grid.new(a)
        4.times do
          g = g.rotate
          @rules[g.render] = b
          @rules[g.flip.render] = b
          # @rules[g.flip(vertically: true).render] = b
        end
        i += 1
      end
    end

    def debug!
      @debug = true
    end


    def fractalize!(grid)
      if grid.width == 2 || grid.width == 3
        new_grid_pattern = @rules[grid.render]
        raise "Unable to find grid pattern!!!" if new_grid_pattern.nil?
        return Grid.new(new_grid_pattern)
      end

      dim = 3 if grid.width % 3 == 0
      dim = 2 if grid.width % 2 == 0 # divide by 2 if possible, otherwise divide by 3

      if dim
        fractured_grids = grid.split(dim).map { |g| fractalize!(g) }
        return Grid.join(fractured_grids)
      end

      raise "Grid Width #{grid.width} is not divisible by 2 or 3???"
    end
  end
end
