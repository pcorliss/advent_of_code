require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Virus
    attr_accessor :debug
    attr_reader :grid, :pos, :dir

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @grid.cells.delete_if do |cell, val|
        val == '.'
      end
      @pos = [@grid.width / 2, @grid.height / 2]
      @dir = CARDINAL_DIRECTIONS.first
    end

    def debug!
      @debug = true
    end

    CARDINAL_DIRECTIONS = [
      [ 0,-1], # North
      [ 1, 0], # East
      [ 0, 1], # South
      [-1, 0], # West
    ]

    CARD_MAP = {
      [ 0,-1] => 0,
      [ 1, 0] => 1,
      [ 0, 1] => 2,
      [-1, 0] => 3,
    }

    def weaken_burst!
      state = @grid[@pos]
      dir_idx = CARD_MAP[@dir]
      l = CARDINAL_DIRECTIONS.length
      infection = false
      case state
      when nil # Clean
        @grid[@pos] = 'W'
        dir_idx -= 1
      when 'W'
        @grid[@pos] = '#'
        infection = true
      when '#'
        @grid[@pos] = 'F'
        dir_idx += 1
      when 'F'
        @grid[@pos] = nil
        dir_idx += 2
      end
      @dir = CARDINAL_DIRECTIONS[dir_idx % l]
      @pos = [@pos[0] + @dir[0], @pos[1] + @dir[1]]
      infection
    end

    def burst!(weakened: false)
      return weaken_burst! if weakened
      infected = @grid[@pos] == '#'
      dir_idx = CARD_MAP[@dir]
      l = CARDINAL_DIRECTIONS.length
      if infected
        dir_idx += 1
        # @grid[@pos] = nil # Should we delete instead?
        @grid.cells.delete(@pos)
      else
        dir_idx -= 1
        @grid[@pos] = '#'
      end
      @dir = CARDINAL_DIRECTIONS[dir_idx % l]
      @pos = [@pos[0] + @dir[0], @pos[1] + @dir[1]]
      !infected
    end

    def run!(n, weakened: false)
      count = 0
      n.times do |i|
        count += 1 if burst!(weakened: weakened)
        puts @grid.render if @debug
        puts "Pos: #{@pos}" if @debug
        puts "" if @debug
        puts "Iterations: #{i+1} - #{count}" if i % 100_000 == 99_999
      end
      count
    end
  end
end
