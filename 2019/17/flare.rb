require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Flare
    attr_accessor :debug
    attr_reader :program, :grid, :visited

    def initialize(input)
      @debug = false
      @program = Advent::IntCode.new(input)
      @grid = Grid.new
    end

    def fill_grid!
      @program.run!
      output = @program.full_output
      width = output.index("\n".ord)
      output.delete("\n".ord)
      @grid = Grid.new(output.map(&:chr), width)
    end

    def intersections
      inter = []
      @grid.cells.each do |cell, val|
        if val == '#' && @grid.neighbors(cell).all? { |ncell, nval| nval == '#' }
          inter << cell
        end
      end
      inter
    end

    def location
      @grid.cells.find do |coord, val|
        %w(^ v < >).include? val
      end.first
    end

    DIRECTION_MAP = {
      '^' => 0,
      '>' => 90,
      'v' => 180,
      '<' => 270,
    }

    def direction
      DIRECTION_MAP[@grid.cells[location]]
    end

    # Grid is inverted
    DELTA_MAP = {
      [0,-1] => 0,
      [1,0] => 90,
      [0,1] => 180,
      [-1,0] => 270,
    }

    def calc_turn(cur_cell, new_cell, direction)
      delta = [
        new_cell[0] - cur_cell[0],
        new_cell[1] - cur_cell[1]
      ]
      dir = DELTA_MAP[delta]
      # puts "Calc Turn: Cur:#{cur_cell} New:#{new_cell} Dir:#{dir} Calc: #{(dir - direction) % 360}" if @debug
      (dir - direction) % 360
    end

    TURN_MAP = {
      90 => 'R',
      270 => 'L',
    }

    def calculate_path
      start_dir = direction
      start_loc = location

      path = []
      pos = start_loc
      dir = start_dir

      @visited = Grid.new
      @visited.cells[pos] = true
      scaffold_count = @grid.cells.count { |coord, val| val == '#' }


      while @visited.cells.count <= scaffold_count do
        neighbors = @grid.neighbors(pos).select do |coord, val|
          val == '#'
        end.map(&:first)
        # We'll need to make sure we travel in a straight line when possible
        next_cell = neighbors.find do |coord|
          calc_turn(pos, coord, dir) == 0
        end
        # Prefer cells we haven't visisted
        next_cell ||= neighbors.find do |coord|
          !@visited.cells[coord]
        end
        next_cell ||= neighbors.first

        binding.pry if next_cell.nil? && @debug
        raise "No valid cells to visist" if next_cell.nil?

        turn = calc_turn(pos, next_cell, dir)
        raise "We shouldn't end up here, turn of 180 degrees encounterd" if turn == 180

        if turn == 0
          # path << 0 unless path.last.is_a? Integer
          path[path.length - 1] += 1
        else
          path << TURN_MAP[turn]
          path << 1
          dir += turn
          dir %= 360
        end

        pos = next_cell
        @visited.cells[pos] = true
      end

      puts "Path: #{path}" if @debug
      path
    end

    def repeated_sections
      path = calculate_path
      repeated = {}
      (2..10).each do |i|
        path.each_cons(i) do |short_path|
          repeated[short_path] ||= 0
          repeated[short_path] += 1
        end
      end
      repeated.each do |k, v|
        repeated.delete(k) if v == 1
      end
      repeated
    end

    def encoding(inp)
      encoded = []
      inp.each do |char|
        if char.is_a?(Integer)
          digits = char.digits.reverse.map { |d| d + 48 }
          encoded.concat digits
        else
          encoded << char.ord
        end
        encoded << ",".ord
      end
      encoded.pop
      encoded << "\n".ord
    end

    def debug!
      @debug = true
    end
  end
end
