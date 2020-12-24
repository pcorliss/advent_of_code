require 'set'

module Advent

  class Hexagon

    attr_reader :instructions, :grid
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
  end
end
