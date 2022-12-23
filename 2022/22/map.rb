require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Map
    attr_accessor :debug, :pos, :dir
    attr_reader :grid, :instructions, :cube_side, :cube_dir, :cube_pos

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

      @cube_side = :A
      @cube_dir = :E
      @cube_pos = [0,0]
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

    DIRS_KEY = {
      N: 0,
      E: 1,
      S: 2,
      W: 3,
    }

    LOOKUP_DIR = [:N, :E, :S, :W]

    DIR_MOD = {
      L: -1,
      R: 1,
    }

    def turn(inst)
      directions = DIRS.keys
      new_idx = directions.index(@dir) + DIR_MOD[inst]
      @dir = directions[new_idx % directions.length]
    end

    def nil_cell?(pos, g = @grid)
      g[pos] == ' ' || g[pos].nil?
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

    def cube_turn(inst)
      directions = DIRS.keys
      new_idx = directions.index(@dir) + DIR_MOD[inst]
      @cube_dir = directions[new_idx % directions.length]
    end

    def offset(x, y, dir)
      offset = dir == :N || dir == :S ? x : y
      offset = cube_side_size - 1 - offset if dir == :S || dir == :W
      offset
    end

    def new_pos_from_offset(offset, edge)
      if edge == :S
        [offset, cube_side_size - 1]
      elsif edge == :N
        [offset, 0]
      elsif edge == :E
        [cube_side_size - 1, offset]
      elsif edge == :W
        [0, offset]
      end
    end

    def run_cube_instruction(inst)
      cube
      # @cube_side = :A
      # @cube_dir = :E 
      # @cube_pos = [0,0]

      g = @cube[@cube_side]

      if inst.is_a? Symbol
        cube_turn(inst)
      else
        delta_x, delta_y = DIRS[@cube_dir]
        inst.times do |i|
          x, y = @cube_pos
          new_pos = [x + delta_x, y + delta_y]
          new_dir = @cube_dir
          new_side = @cube_side
          # We've reached an edge
          if nil_cell?(new_pos, g)
            # Find Side:
            new_side, dir_changes = EDGE_MAP[@cube_side].find do |new_side, dir_changes|
              dir_changes.first == @cube_dir
            end

            # [1] pry(#<Advent::Map>)> new_side
            # => :F
            # [2] pry(#<Advent::Map>)> dir_changes
            # => [:N, :S]
            
            new_dir = LOOKUP_DIR[(DIRS_KEY[dir_changes.last] + 2) % DIRS_KEY.length]

            offset = offset(x, y, @cube_dir)
            new_pos = new_pos_from_offset(offset, dir_changes.last)

            # binding.pry if @debug
            raise if nil_cell?(new_pos, @cube[new_side])
          end
          break if g[new_pos] == '#'
          @cube_side = new_side
          @cube_dir = new_dir
          @cube_pos = new_pos
        end
      end
    end

    def run
      @instructions.each do |inst|
        run_instruction(inst)
      end
    end

    def run_cube
      @instructions.each do |inst|
        run_cube_instruction(inst)
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
      @cube_grid_map = {}
      @orientation_map = {}
      # Find initial side
      visited = Set.new
      x, y = [0,0]
      6.times do |i|
        x = i * cube_side_size
        y = 0
        visited.add [x,y]
        next if nil_cell?([x,y])
        @cube[:A] = Grid.new(@grid.render(0, [x,y], [x+cube_side_size - 1,y+cube_side_size - 1]))
        @cube_grid_map[:A] = [x,y]
        @orientation_map[:A] = 0
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
          x, y = @cube_grid_map[cube_key]
          # binding.pry if x.nil?
          raise "No Cube Found" if x.nil?
          x += x_delta * cube_side_size
          y += y_delta * cube_side_size
          puts "\tChecking for new cube at #{x} #{y}" if @debug
          next if nil_cell?([x,y])
          next if visited.include? [x,y]
          visited.add [x,y]

          # BUG HERE
          # Need to take into account orientation before using edge map
          turned_times = @orientation_map[cube_key]
          oriented = DIRS_KEY.keys[DIRS_KEY[dir] + turned_times]
          side, dir_changes = EDGE_MAP[cube_key].find do |side, dir_changes|
            # dir_changes.first == dir
            dir_changes.first == oriented
          end

          puts "\tSide: #{side} #{dir_changes}" if @debug
          binding.pry if @cube[side] && @debug
          raise "Already loaded this cube!!!" if @cube[side]
          
          start_dir, end_dir = dir_changes
          start_idx = DIRS_KEY[start_dir]
          end_idx = DIRS_KEY[end_dir]
          end_idx -= 2
          # end_idx += orientation
          right_turns = (turned_times + end_idx - start_idx) % DIRS_KEY.length
          puts "\tTurning #{right_turns} times #{start_idx} #{end_idx} #{DIRS_KEY.length}" if @debug
          # We need to handle rotations here

          @cube[side] = Grid.new(
            @grid.render(0, [x,y], [x+cube_side_size - 1,y+cube_side_size - 1])
          )
          right_turns.times { @cube[side] = @cube[side].rotate }
          # Number of turns to orient this with North Up
          @orientation_map[side] = right_turns
          @cube_grid_map[side] = [x,y]
        end

        i += 1
        raise "Too many iterations!!" if i > 1_000
      end

      @cube
    end
  
    # 0,0 -> 3,0 -> 0,3 -> 0,3 (3x3)
    # 1,1 -> 2,1 -> 2,2 -> 1,2 (4x4)
    def translate_cube(side = @cube_side, pos = @cube_pos, dir = @cube_dir)
      x, y = @cube_grid_map[side]
      turns = @orientation_map[side]
      g = Grid.new
      g.width = cube_side_size
      g.height = cube_side_size
      p_x, p_y = pos
      g[p_x,p_y] = '.'
      ((DIRS_KEY.length - turns) % DIRS_KEY.length).times { g = g.rotate }
      p_x, p_y = g.find('.')

      new_dir = LOOKUP_DIR[(DIRS_KEY[dir] - turns) % DIRS_KEY.length]
      [[p_x + x, p_y + y], new_dir]
    end
  end
end
