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

    # Converts a position off the grid, to the grids value
    def translate(pos)
      x, y = pos
      @grid[x % @grid.width, y % @grid.height]
    end

    def generate_steps(pos, s)
      @position_steps = [1]
      positions = Set.new([pos])
      s.times do
        positions = positions.map do |pos|
          @grid.neighbor_coords(pos).select do |npos|
            translate(npos) == '.'
          end
        end.flatten(1).to_set
        @position_steps << positions.length
        positions
      end
      positions
    end

    def steps(pos, s)
      minimum_steps_for_cycles = [@grid.width * 3, 11*7].max
      generate_steps(pos, [s, minimum_steps_for_cycles].min)
      return @position_steps[s] if @position_steps[s]

      sub1 = @position_steps.each_cons(2).map { |a, b| b - a }

      # sub1.each_slice(@grid.width).to_a.last(2).each do |slice|
      #   puts "Slice: #{slice}" if @debug
      # end

      # We don't need to keep adding to sub1, we could just calculate its value
      # based on position, it will always be offset + x * diff, where x is the index div grid width
      # we might be able to just increment counters as well
      while @position_steps.length <= s do
        sub1 << sub1[-@grid.width] + (sub1[-@grid.width] - sub1[-2*@grid.width])
        # puts "New Sub: #{sub1.last}" if @debug
        @position_steps << @position_steps.last + sub1.last
        # puts "New Position: [#{@position_steps.length - 1}] #{@position_steps[-1]}" if @debug
      end

      @position_steps[s]
    end
    # For the sample input
    # There's a pattern in the diffs every 11 steps, (also the width/height of grid)
    # You can see it in the diffs for the first 100 or so terms
    # After the first 30 or so terms
    # We can use that pattern to generate the sequence of steps
  end
end
