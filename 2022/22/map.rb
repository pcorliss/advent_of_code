require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Map
    attr_accessor :debug, :pos, :dir
    attr_reader :grid, :instructions

    def initialize(input)
      @debug = false
      map = []
      read_instructions = false
      input.each_line do |line|
        if line.strip.empty?
          read_instructions = true
          next
        end
        if read_instructions
          @instructions = []
          line.each_char do |char|
            if char == 'R' || char == 'L'
              @instructions << char.to_sym
            elsif @instructions.empty?
              @instructions << char
            elsif @instructions.last.is_a? String
              @instructions.last << char
            else
              @instructions << char
            end
          end
          @instructions.map! do |inst|
            if inst.is_a? String
              inst.to_i
            else
              inst
            end
          end
        else
          map << line.chomp
        end
      end
      @grid = Grid.new(map.join("\n"))

      @dir = :E
      @pos = @grid.find('.')
    end

    def debug!
      @debug = true
    end

    DIRS = {
      N: [ 0, -1],
      E: [ 1,  0],
      S: [ 0,  1],
      W: [-1,  0],
    }

    DIR_MOD = {
      L: -1,
      R: 1,
    }

    def turn(inst)
      directions = DIRS.keys
      new_idx = directions.index(@dir) + DIR_MOD[inst]
      @dir = directions[new_idx % directions.length]
    end

    def nil_cell?(pos)
      @grid[pos] == ' ' || @grid[pos].nil?
    end

    def run_instruction(inst)
      if inst.is_a? Symbol
        turn(inst)
      else
        delta_x, delta_y = DIRS[@dir]
        inst.times do |i|
          x, y = @pos
          new_pos = [x + delta_x, y + delta_y]
          # We've reached an edge
          if nil_cell?(new_pos)
            # READ -delta_x && -delta_y until nil or space
            search_x, search_y = x, y
            until nil_cell?([search_x, search_y]) do
              search_x -= delta_x
              search_y -= delta_y
            end
            new_pos = [search_x + delta_x, search_y + delta_y]
          end
          break if @grid[new_pos] == '#'
          @pos = new_pos
        end
      end
    end

    def run
      @instructions.each do |inst|
        run_instruction(inst)
      end
    end

    def password
      facing = { N: 3, E: 0, S: 1, W: 2, }
      x, y = @pos
      row = y + 1
      col = x + 1
      1000 * row + 4 * col + facing[@dir]
    end
  end
end
