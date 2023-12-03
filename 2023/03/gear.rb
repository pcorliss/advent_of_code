require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Gear
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @grid.cells.each do |pos, val|
        @grid.cells[pos] = val.to_i if val =~ /\d/
        @grid.cells[pos] = nil if val == '.'
      end
    end

    def debug!
      @debug = true
    end

    def read_number(pos)
      x, y = pos
      val = @grid[pos]
      while val.is_a? Integer do
        x -= 1
        val = @grid[x, y]
      end

      x += 1
      val = @grid[x, y]
      part_num = val
      start = [x,y]

      while val.is_a? Integer do
        x += 1
        val = @grid[x, y]
        if val.is_a? Integer
          part_num *= 10
          part_num += val
        end  
      end

      [part_num, start]
    end

    def part_nums
      parts = []
      used_part_positions = Set.new
      @grid.cells.each do |pos, val|
        next if val.nil?
        next if val.is_a? Integer

        @grid.neighbors(pos, true).each do |n_pos, n_val|
          if n_val.is_a? Integer
            part, start_pos = read_number(n_pos)
            next if used_part_positions.include? start_pos
            used_part_positions << start_pos
            parts << part
          end
        end
      end

      parts
    end

    def part_nums_sum
    end
  end
end
