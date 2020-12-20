require 'set'

module Advent

  class Jigsaw

    # Thoughts on solving part 1
    # 1. Load all tiles, look for tiles that have no matches on two sides, those are our corners. Don't bother arranging
    # 2. Compute an edge code (binary) for each edge, flipped and not-flipped. Use that to join tiles up easier.
    # 3. Track transforms in the grid (flips (%2) and rotations (%4))
    # 4. Is there a binary operator to flip a binary string? int.to_s(2).reverse.to_i(2) ?
    #
    attr_reader :tiles
    def initialize(input)
      @tiles = input.split("\n\n").map do |tile_in|
        Tile.new(tile_in)
      end
    end

    def corners
      @edge_map = {}
      @edge_count = {}
      @tiles.each do |tile|
        tile.edges.each do |edge|
          @edge_map[edge] ||= []
          @edge_map[edge] << tile
          @edge_count[edge] = @edge_map[edge].count
        end
      end
      #puts "Edge map: #{@edge_count}"
      @tiles.select do |tile|
        matching_edges = tile.edges.count do |edge|
          @edge_count[edge] >= 2
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

    def row_to_binary(row)
      # binding.pry
      bin_string = row.gsub('.', '0').gsub('#', '1')
      a = bin_string.to_i(2)
      b = bin_string.reverse.to_i(2)
      [a, b].min
    end
  end
end
