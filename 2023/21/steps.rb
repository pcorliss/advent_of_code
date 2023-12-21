require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Steps
    attr_accessor :debug
    attr_reader :start, :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @start = @grid.find('S')
      @grid[@start] = '.'
    end

    def debug!
      @debug = true
    end

    # This is far too slow for part 1
    def steps_by_hash_memoization(pos, s)
      positions_loookup = Hash.new do |h, (x, y, steps)|
        positions = Set.new
        if steps == 0
          positions << [x,y]
        else
          @grid.neighbors([x, y]).each do |npos, val|
            if val == '.'
              positions |= h[[*npos, steps - 1]]
            end
          end
        end
        positions
      end

      positions_loookup[[*pos, s]]
    end

    def steps(pos, s)
      positions = Set.new
      positions << pos
      s.times do
        positions = positions.map do |pos|
          @grid.neighbors(pos).select do |npos, val|
            val == '.'
          end.keys
        end.flatten(1).to_set
      end
      positions
    end
  end
end
