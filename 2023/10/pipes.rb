require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Pipes
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
    end

    def debug!
      @debug = true
    end

    def starting_point
      c, _ = @grid.cells.find do |cell, val|
        val == 'S'
      end

      c
    end

    PIPE_MAP = {
      '-' => [[-1, 0],[ 1, 0]],
      '|' => [[ 0,-1],[ 0, 1]],
      'L' => [[ 1, 0],[ 0,-1]],
      'F' => [[ 1, 0],[ 0, 1]],
      'J' => [[-1, 0],[ 0,-1]],
      '7' => [[-1, 0],[ 0, 1]],
    }

    def starting_directions
      dirs = []
      start = starting_point
      puts "Start: #{start}" if @debug
      @grid.neighbors(start).each do |pos, val|
        puts "Pos: #{pos}, Val: #{val}}" if @debug
        next if val == '.' || val.nil? || PIPE_MAP[val].nil?
        PIPE_MAP[val].each do |dir_x, dir_y|
          pos_x, pos_y = pos
          d_x = pos_x + dir_x
          d_y = pos_y + dir_y
          dirs << [-dir_x, -dir_y] if [d_x, d_y] == start
        end
      end
      dirs
    end

    def first_steps
      start = starting_point
      starting_directions.map do |dir_x, dir_y|
        pos_x, pos_y = start
        d_x = pos_x + dir_x
        d_y = pos_y + dir_y
        [d_x, d_y]
      end
    end

    DIR_RIGHT_EDGE = {
      [ 0,-1] => [ 1, 0], # North, Edge is East
      [ 0, 1] => [-1, 0], # South, Edge is West
      [-1, 0] => [ 0,-1], # West, Edge is North
      [ 1, 0] => [ 0, 1], # East, Edge is South
    }

    def right_edge(pos, dir)
      pos_x, pos_y = pos
      d_x, d_y = DIR_RIGHT_EDGE[dir]
      [pos_x + d_x, pos_y + d_y]
    end

    # Because it's a loop with only one entrance/exit,
    # we can walk both directions until we hit a spot that has been visited
    def double_walk!
      start = starting_point
      @steps = 0
      @visited = {starting_point => 0}
      @edges = Set.new
      positions = first_steps

      until positions.empty? do
        @steps += 1
        raise "Too many steps!" if @steps > 10_000
        new_positions = []
        positions.each_with_index do |pos, idx|
          pos_x, pos_y = pos
          @visited[pos] = @steps
          val = @grid[pos]
          raise "Unexpected #{val} val found for position #{pos}" if val == '.' || val.nil? || PIPE_MAP[val].nil?
          PIPE_MAP[val].each do |dir_x, dir_y|
            new_pos = [pos_x + dir_x, pos_y + dir_y]
            next if @visited.has_key? new_pos
            new_positions << new_pos
            # Only on the first position, so that "right" is consistent
            puts "New Pos: #{new_pos}, Dir: #{[dir_x, dir_y]}, Edge: #{right_edge(new_pos, [dir_x, dir_y])}" if @debug && idx == 0
            @edges << right_edge(new_pos, [dir_x, dir_y]) if idx == 0
          end
        end
        positions = new_positions
      end
    end

    def single_walk!
      start = starting_point
      steps = 0
      visited = {starting_point => 0}
      edges = Set.new
      pos = first_steps.first

      until pos == start do
        steps += 1
        raise "Too many steps!" if steps > 100_000
        new_position = nil

        pos_x, pos_y = pos
        visited[pos] = steps
        val = @grid[pos]
        raise "Unexpected #{val} val found for position #{pos}" if val == '.' || val.nil? || PIPE_MAP[val].nil?
        PIPE_MAP[val].each do |dir_x, dir_y|
          new_pos = [pos_x + dir_x, pos_y + dir_y]
          if visited.has_key? new_pos
            next unless new_pos == start && steps > 1
          end
          new_position = new_pos
          puts "New Pos: #{new_pos}, Dir: #{[dir_x, dir_y]}, Edge: #{right_edge(new_pos, [dir_x, dir_y])}" if @debug
          edges << right_edge(new_pos, [dir_x, dir_y])
          break
        end
        raise "No new position found for Pos: #{pos} and Val: #{val}" if new_position.nil?
        pos = new_position
      end

      [edges, visited]
    end

    def steps
      double_walk!
      @steps
    end

    def mark_edge
      edges, visited = single_walk!

      puts "Edges: #{edges}" if @debug
      puts "Visited: #{visited.keys}" if @debug
      puts "Remainder: #{edges - visited.keys}" if @debug

      edges - visited.keys
    end

    def flood_fill
      edges, visited = single_walk!
      cells_to_flood = edges
      flood_grid = Grid.new

      until cells_to_flood.empty? do
        new_cells_to_flood = Set.new
        cells_to_flood.each do |pos|
          next if @grid[pos].nil? # escaped the map
          next if visited.has_key? pos # don't cross ring boundaries
          next if flood_grid[pos] # don't add a second time
          flood_grid[pos] = 'X'
          @grid.neighbors(pos).each do |pos, val|
            new_cells_to_flood << pos
          end
        end
        cells_to_flood = new_cells_to_flood
      end

      [visited, flood_grid]
    end

    def flood_fill_count
      visited, flood_grid = flood_fill
      total = @grid.cells.count
      marked = flood_grid.cells.count
      if flood_grid.cells.keys.flatten.include? 0
        total - marked - visited.count
      else
        marked
      end
    end
  end
end
