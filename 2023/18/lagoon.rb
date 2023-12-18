require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Lagoon
    attr_accessor :debug
    attr_reader :commands, :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new
      @commands = input.each_line.map do |line|
        line.chomp!
        dir, len, color = line.match(/([RULD]) (\d+) \(#(\h{6})\)/).captures
        [dir.to_sym, len.to_i, color]
      end
    end

    def debug!
      @debug = true
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

    def lagoon_size
      @grid.find_all('#').count
    end
  end
end
