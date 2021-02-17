require 'set'
require '../lib/grid.rb'

module Advent

  class Tiles
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
    end

    def debug!
      @debug = true
    end

    def trap?(pos)
      return @grid[pos] == '^' if @grid[pos]
      x, y = pos
      return false if x < 0 || x > @grid.width - 1
      return false if y < 0
      upper_row = y - 1
      left   = trap?([x-1, upper_row])
      center = trap?([x  , upper_row])
      right  = trap?([x+1, upper_row])

      result = !(left && center && right) && ((left && center) || (center && right) || (!right && left) || (!left && right))
      puts "#{pos}:#{left}-#{center}-#{right} = #{result}" if @debug
      @grid[pos] = result ? '^' : '.'
      result
    end

    def fill_rows!(height)
      (0...@grid.width).each { |x| trap?([x, height - 1]) }
    end

    def safe_tiles
      @grid.cells.count do |pos, val|
        val == '.'
      end
    end
  end
end
