require 'set'

module Advent

  class Jigsaw

    # Thoughts on solving part 1
    # 1. Load all tiles, look for tiles that have no matches on two sides, those are our corners. Don't bother arranging
    # 2. Compute an edge code (binary) for each edge, flipped and not-flipped. Use that to join tiles up easier.
    # 3. Track transforms in the grid (flips (%2) and rotations (%4))
    # 4. Is there a binary operator to flip a binary string? int.to_s(2).reverse.to_i(2) ?
    # Part 1 conclusion, we did indeed only need the corners and the edges were unique such that matching them was easy.
    # Part 2 however looks to be harder since we will have to actually build the grid.
    # 1. Build the grid, fortunately edges are unique
    #   1a. start with a corner (orientation doesn't matter)
    #   1b. find the first edge that matches another tile, orient them, and place in grid
    #   1c. ???
    # 2. Remove the borders and build a big canvas
    # 3. Find sea monster in canvas???
    # 4. subtract sea-monster '#' count * sea monsters from total hash count
    attr_reader :tiles, :grid
    def initialize(input)
      @tiles = input.split("\n\n").map do |tile_in|
        Tile.new(tile_in)
      end
      @grid = []
      @width = Integer.sqrt @tiles.count
    end

    UP = 0
    RIGHT = 1
    DOWN = 2
    LEFT = 3

    def orient!
      tiles = @tiles.clone
      first_tile = corners.first
      tiles.delete(first_tile)
      @grid << first_tile
      next_tile = adjoining_tiles(first_tile).first
      matching_edge = (first_tile.edges & next_tile.edges).first
      @grid << next_tile
      # first time orientation
      while first_tile.edges[RIGHT] != matching_edge do
        # puts "Looking for #{matching_edge} in #{first_tile.edges} :: #{first_tile.edges[RIGHT]}"
        first_tile.rotate!
      end
      while next_tile.edges[LEFT] != matching_edge do
        # puts "Looking for #{matching_edge} in #{next_tile.edges} :: #{next_tile.edges[LEFT]}"
        next_tile.rotate!
      end
      if next_tile.absolute_edges[LEFT] != first_tile.absolute_edges[RIGHT]
        next_tile.flip!
        next_tile.rotate!
        next_tile.rotate!
      end

      x = 2
      y = 0
      prev_tile = next_tile
      direction = RIGHT
      opp = LEFT
      while x < @width && y < @width do
        matching_edge = prev_tile.edges[direction]
        abs_edge = prev_tile.absolute_edges[direction]
        next_tile = (edge_map[matching_edge] - [prev_tile]).first

        # binding.pry if prev_tile.id == 2311
        # binding.pry if next_tile.nil?

        while next_tile.edges[opp] != matching_edge do
          next_tile.rotate!
        end
        if next_tile.absolute_edges[opp] != abs_edge
          next_tile.flip!
          if direction == RIGHT
            next_tile.rotate!
            next_tile.rotate!
          end
        end

        # binding.pry if next_tile.absolute_edges[opp] != abs_edge

        @grid[x + y * @width] = next_tile

        # Walk the grid
        x += 1
        direction = RIGHT
        opp = LEFT
        prev_tile = next_tile
        if x >= @width
          prev_tile = @grid[y * @width]
          direction = DOWN
          opp = UP
          y += 1
          x = 0
        end
      end

      @grid
    end

    def adjoining_tiles(tile)
      adj_tiles = tile.edges.inject(Set.new) do |set, edge|
        edge_map[edge].each do |t|
          set.add t
        end
        set
      end
      adj_tiles.delete tile
      adj_tiles
    end

    def edge_count
      return @edge_count if @edge_count
      edge_map
      @edge_count
    end

    def edge_map
      return @edge_map if @edge_map
      @edge_map = {}
      @edge_count = {}
      @tiles.each do |tile|
        tile.edges.each do |edge|
          @edge_map[edge] ||= []
          @edge_map[edge] << tile
          @edge_count[edge] = @edge_map[edge].count
        end
      end
      @edge_map
    end

    def corners
      # puts "Edge map: #{@edge_count}"
      @tiles.select do |tile|
        matching_edges = tile.edges.count do |edge|
          edge_count[edge] >= 2
        end
        matching_edges == 2
      end
    end
  end

  class Tile
    attr_reader :id, :grid

    def initialize(input)
      @grid = []
      input.each_line do |line|
        line.chomp!
        if line =~ /^Tile (\d+):$/
          @id = $1.to_i
        else
          @grid << line
        end
      end
    end

    def edges
      # We may need to worry about orientation when matching edges but lets see what we get first.
      [
        row_to_binary(@grid.first),
        row_to_binary(@grid.map {|r| r[-1]}.join("")),
        row_to_binary(@grid.last),
        row_to_binary(@grid.map {|r| r[0]}.join("")),
      ]
    end

    def absolute_edges
      [
        row_to_binary(@grid.first, false),
        row_to_binary(@grid.map {|r| r[-1]}.join(""), false),
        row_to_binary(@grid.last, false),
        row_to_binary(@grid.map {|r| r[0]}.join(""), false),
      ]
    end

    def row_to_binary(row, min = true)
      # binding.pry
      bin_string = row.gsub('.', '0').gsub('#', '1')
      a = bin_string.to_i(2)
      b = bin_string.reverse.to_i(2)
      if min
        [a, b].min
      else
        a
      end
    end

    def rotate!
      @grid = @grid.map {|l| l.chomp.chars}.transpose.map(&:reverse).map(&:join)
    end

    def flip!
      @grid = @grid.map {|l| l.chomp.reverse}
    end
  end
end
