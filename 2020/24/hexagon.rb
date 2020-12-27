require 'set'

module Advent

  class Hexagon

    attr_reader :instructions, :grid, :day
    attr_accessor :debug

    def initialize(input)
      @debug = false
      @grid = {}
      @instructions = input.lines.map do |line|
        line.chomp!
        i = 0
        acc = []
        while i < line.length do
          char = line[i]
          if char =~ /^[ew]$/
            acc << char
            i += 1
          else
            chars = line[i..i+1]
            acc << chars
            i += 2
          end
        end
        acc
      end
    end

    DIRECTIONS =  {
      "e" => [1,0],
      "w" => [-1,0],
      "ne" => [0,-1],
      "nw" => [-1,-1],
      "se" => [0,1],
      "sw" => [-1,1],
    }

    SHIFTED_DIRECTIONS = {
      "e" => [1,0],
      "w" => [-1,0],
      "ne" => [1,-1],
      "nw" => [0,-1],
      "se" => [1,1],
      "sw" => [0,1],
    }

    def navigate(directions)
      directions.inject([0,0]) do |acc, direction|
        change = DIRECTIONS[direction]
        change = SHIFTED_DIRECTIONS[direction] if acc[1] % 2 == 1
        puts "Start: #{acc} Direction: #{direction} Change: #{change}" if @debug
        acc[0] += change[0]
        acc[1] += change[1]
        puts "Finish: #{acc}" if @debug
        acc
      end
    end

    def flip!(directions)
      coords = navigate(directions)
      @grid[coords] ||= 0
      @grid[coords] += 1
    end

    def run!
      @instructions.each do |inst|
        flip!(inst)
      end
    end

    def adjacent(x, y)
      acc = []
      directions = DIRECTIONS
      directions = SHIFTED_DIRECTIONS if y % 2 == 1
      directions.each do |dir, shift|
        acc << [x + shift[0], y + shift[1]]
      end
      acc
    end

    def day!
      @day ||= 0
      @day += 1

      neighbors_count = {}
      @grid.each do |coord, val|
        next unless val % 2 == 1
        adjacent(*coord).each do |ncoord|
          neighbors_count[ncoord] ||= 0
          neighbors_count[ncoord] += 1
        end
      end
      
      new_grid = @grid.clone

      @grid.each do |coord, val|
        if val % 2 == 1 && neighbors_count[coord].nil?
          new_grid[coord] += 1

        end
      end

      neighbors_count.each do |coord, adj_count|
        # black tiles
        if @grid[coord] && @grid[coord] % 2 == 1
          if adj_count > 2
            new_grid[coord] += 1
          end
        # white tiles
        else
          if adj_count == 2
            new_grid[coord] ||= 0
            new_grid[coord] += 1
          end
        end
      end

      # flipped = new_grid.values.sum - @grid.values.sum

      @grid = new_grid

      # Return num of black tiles
      @grid.values.count {|t| t % 2 == 1}
    end
  end
end
