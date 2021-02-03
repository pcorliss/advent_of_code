require 'set'
require '../lib/grid.rb'

module Advent

  class Code
    attr_accessor :debug
    attr_reader :grid_pos

    def initialize(input)
      @debug = false
      if input =~ /Enter the code at row (\d+), column (\d+)./
        @grid_pos = [$2.to_i, $1.to_i]
      end
    end

    def debug!
      @debug = true
    end

    def grid_n(pos)
      col, row = pos
      starting = 1.upto(row - 1).sum + 1
      starting + (row + 1).upto(row + col - 1).sum
    end

    CODE = 20151125

    def code_gen(n)
      code = CODE
      (n-1).times do
        code = (code * 252533) % 33554393
      end
      code
    end
  end
end
