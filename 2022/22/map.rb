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

    def cube_side_size
      return @cube_side_size if @cube_side_size
      count = @grid.cells.count do |cell, val|
        !nil_cell?(cell)
      end
      count /= 6
      @cube_side_size = Math.sqrt(count).to_i
    end

    # Edge Mapping to notional Grids
    #    D....B....B....B....B...D
    #   ABC..ADC..ECD..DAE..AEC.CFA
    #    E....F....F....F....F...E

    EDGE_MAP = {
      A: {B: [:W, :N], C: [:S, :N], D: [:E, :N], F: [:N, :S]},
      B: {A: [:N, :W], C: [:E, :W], E: [:S, :W], F: [:W, :W]},
      C: {A: [:N, :S], B: [:W, :E], D: [:E, :W], E: [:S, :N]},
      D: {A: [:N, :E], C: [:W, :E], E: [:S, :E], F: [:E, :E]},
      E: {B: [:W, :S], C: [:N, :S], D: [:E, :S], F: [:S, :N]},
      F: {A: [:S, :N], B: [:W, :N], D: [:E, :E], E: [:N, :S]},
    }

    CARDINAL_DIRECTIONS = {
      W: [-1, 0], # West
      E: [ 1, 0], # East
      N: [ 0,-1], # North
      S: [ 0, 1], # South
    }

    def cube
      return @cube if @cube
      @cube = {}
      cube_grid_map = {}
      # Find initial side
      visited = Set.new
      x, y = [0,0]
      6.times do |i|
        x = i * cube_side_size
        y = 0
        visited.add [x,y]
        next if nil_cell?([x,y])
        @cube[:A] = Grid.new(@grid.render(0, [x,y], [x+cube_side_size - 1,y+cube_side_size - 1]))
        cube_grid_map[:A] = [x,y]
        break
      end

      i = 0 
      6.times do |cube_marker|
        cube_key = @cube.keys[cube_marker]
        puts "Cube Key: #{cube_key}" if @debug
        # binding.pry if cube_key.nil?
        raise "No Cube Key Found" if cube_key.nil?
        CARDINAL_DIRECTIONS.each do |dir, delta|
          x_delta, y_delta = delta
          x, y = cube_grid_map[cube_key]
          # binding.pry if x.nil?
          raise "No Cube Found" if x.nil?
          x += x_delta * cube_side_size
          y += y_delta * cube_side_size
          puts "\tChecking for new cube at #{x} #{y}" if @debug
          next if nil_cell?([x,y])
          next if visited.include? [x,y]
          visited.add [x,y]

          side, dir_changes = EDGE_MAP[cube_key].find do |side, dir_changes|
            dir_changes.first == dir
          end

          puts "\tSide: #{side} #{dir_changes}" if @debug
          start_dir, end_dir = dir_changes
          start_idx = DIRS.keys.index(start_dir)
          end_idx = DIRS.keys.index(end_dir)
          end_idx -= 2
          end_idx += DIRS.keys.length if end_idx < start_idx
          right_turns = end_idx - start_idx
          puts "\tTurning #{right_turns} times #{start_idx} #{end_idx} #{DIRS.keys.length}" if @debug
          # We need to handle rotations here

          @cube[side] = Grid.new(
            @grid.render(0, [x,y], [x+cube_side_size - 1,y+cube_side_size - 1])
          )
          right_turns.times { @cube[side] = @cube[side].rotate }

          cube_grid_map[side] = [x,y]
        end

        i += 1
        raise "Too many iterations!!" if i > 1_000
      end

      @cube
    end
    
  end
end
