require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Lagoon
    attr_accessor :debug
    attr_reader :commands, :grid, :hex_commands

    HEX_TO_DIR = {
      '0' => :R,
      '1' => :D,
      '2' => :L,
      '3' => :U,
    }

    def initialize(input)
      @debug = false
      @grid = Grid.new
      @hex_commands = []
      @commands = input.each_line.map do |line|
        line.chomp!
        dir, len, color = line.match(/([RULD]) (\d+) \(#(\h{6})\)/).captures
        hex_dir = HEX_TO_DIR[color[5]]
        hex_len = color[0..4].to_i(16)
        @hex_commands << [hex_dir, hex_len]
        [dir.to_sym, len.to_i, color]
      end
    end

    def debug!
      @debug = true
    end

    def swap_commands
      @commands = @hex_commands
    end

    DIR_MAP = {
      R: [1,0],
      L: [-1,0],
      U: [0,-1],
      D: [0,1],
    }

    def cut_edge
      @commands.each do |dir, len, color|
        @grid.draw!(DIR_MAP[dir], len, '#')
      end
    end

    def fill_lagoon
      pos = [1,1]
      until @grid[pos].nil? do
        pos[0] += 1
      end

      cells = @grid.cells.keys
      xmin, xmax = cells.map(&:first).minmax
      ymin, ymax = cells.map(&:last).minmax

      yavg = (ymax + ymin)/2

      pos = [xmin, yavg]
      until @grid[pos] == '#' do
        pos[0] += 1
      end

      # There's still a chance we'll hit a line of X but this should be fine
      until @grid[pos].nil? do
        pos[0] += 1
      end

      # require 'pry';
      # binding.pry if @debug
      neighbors = [pos]
      i = 0
      until neighbors.empty? do
        pos = neighbors.pop
        @grid[pos] = '#'
        neighbors.concat(
          @grid
          .neighbor_coords(pos, true)
          .select { |npos| @grid[npos].nil? }
        )
        # binding.pry if @debug
        # puts "Neighbors: #{neighbors.inspect}" if @debug
        i += 1
        raise "Too many iterations!!! #{i}" if i > 1000000
      end
    end

    def lagoon_size_slow
      @grid.find_all('#').count
    end

    # Shoelace formula + Pick's Theorem
    def lagoon_size
      x, y = [0, 0]
      perimeter = 0
      area = 0
      @commands.each do |dir, len, _|
        dx, dy = DIR_MAP[dir]
        dx, dy = dx * len, dy * len
        nx, ny = x+dx, y+dy
        perimeter += len
        area += x * ny - nx * y
        x, y = nx, ny
      end
      area / 2 + perimeter / 2 + 1
    end
  end
end
