require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require '../10/knots.rb'

module Advent

  class Defrag
    attr_accessor :debug
    attr_reader :seed, :grid

    def initialize(input)
      @debug = false
      @seed = input.chomp
      @grid = Grid.new
    end

    def debug!
      @debug = true
    end

    def knot_hash(str)
      k = Knots.new(str)
      k.run_prime!
      k.to_hex
    end

    def knot_bits_slow(str)
      ("%0128b" % knot_hash(str).to_i(16)).chars.map(&:to_i)
    end

    def knot_bits(str)
      num = knot_hash(str).to_i(16)
      128.times.inject([]) do |acc, i|
        j = 127 - i
        acc << ((num >> j) & 1)
        acc
      end
    end

    def fill_grid!
      128.times do |i|
        knot_bits("#{@seed}-#{i}").each_with_index do |bit, j|
          char = bit == 1 ? '#' : '.'
          @grid[j, i] = char
        end
      end
    end

    def used_squares
      @grid.cells.values.count { |v| v == '#' }
    end

    def grouping
      group_grid = Grid.new
      counter = 1
      @grid.cells.each do |cell, val|
        if val == '.'
          group_grid[cell] = '.'
          next
        end
        next if group_grid[cell]

        neighbors = {cell => val}
        i = 0
        until neighbors.empty? do
          # puts "#{counter}: Neighbors: #{neighbors}" if @debug
          new_neighbors = {}
          neighbors.each do |n_cell, n_val|
            next if n_val == '.'
            next if group_grid[n_cell]

            new_neighbors.merge! @grid.neighbors(n_cell)
            group_grid[n_cell] = counter
          end

          neighbors = new_neighbors
          i += 1
          raise "Too many iterations!!! #{i}" if i > 1000
        end

        # puts "Group Grid:\n#{group_grid.render(0)}" if @debug
        counter += 1
        # break if counter > 2000
      end

      @grid = group_grid
      counter - 1
    end
  end
end
