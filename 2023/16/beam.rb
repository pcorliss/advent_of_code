require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Beam
    attr_accessor :debug
    attr_reader :grid, :beam_map

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
    end

    def debug!
      @debug = true
    end

    BEAM_RENDER = {
      [1,0] => '>',
      [-1,0] => '<',
      [0,1] => 'v',
      [0,-1] => '^',
    }

    def render_grid
      new_grid = Grid.new
      @grid.cells.each do |pos, cell|
        if cell == '.' && @beam_map[pos]
          if @beam_map[pos].count > 1
            new_grid[pos] = @beam_map[pos].count
          else
            new_grid[pos] = BEAM_RENDER[@beam_map[pos].first]
          end
        else
          new_grid[pos] = cell
        end
      end
      new_grid.render
    end

    def render_energized
      new_grid = Grid.new
      e = 0
      @grid.cells.each do |pos, cell|
        if beam_map[pos]
          new_grid[pos] = '#'
          e += 1
        else
          new_grid[pos] = '.'
        end
      end
      new_grid.render
    end

    # We start off the grid so we properly handle a cell that's not a '.'
    # x, y, dx, dy
    def energize(starting_beam = [-1,0,1,0])
      beams = [starting_beam]
      @beam_map = {}
      i = 0
      until beams.empty? do
        i += 1
        raise "Too many Iterations: #{i} -- #{beams.count}" if i > 100_000
        beam = beams.pop #DFS
        x, y, dx, dy = beam
        new_pos = [x + dx, y + dy]
        nx, ny = new_pos
        cell = grid[new_pos]
        next if cell.nil?
        next if @beam_map[new_pos] && @beam_map[new_pos].include?([dx, dy])
        @beam_map[new_pos] ||= []
        @beam_map[new_pos] << [dx, dy]
        case cell
        when '.'
          beams << [nx, ny, dx, dy]
        when '|'
          if dx == 0
            # veritical travel, ignore splitter
            beams << [nx, ny, dx, dy]
          else
            # horizontal travel, split veritcally
            beams << [nx, ny, 0, 1]
            beams << [nx, ny, 0,-1]
          end
        when '-'
          if dx == 0
            # veritical travel, split horizontally
            beams << [nx, ny,-1, 0]
            beams << [nx, ny, 1, 0]
          else
            # horizontal travel, ignore splitter
            beams << [nx, ny, dx, dy]
          end
        when '/'
          if dx == 0 && dy == 1 # travel down
            beams << [nx, ny,-1, 0]
          elsif dx == 0 && dy == -1 # travel up
            beams << [nx, ny, 1, 0]
          elsif dx == 1 && dy == 0 # travel right
            beams << [nx, ny, 0,-1]
          elsif dx == -1 && dy == 0 # travel left
            beams << [nx, ny, 0, 1]
          else
            raise "Unexpected direction: #{dx}, #{dy} at #{new_pos}"
          end
        when '\\'
          if dx == 0 && dy == 1 # travel down
            beams << [nx, ny, 1, 0]
          elsif dx == 0 && dy == -1 # travel up
            beams << [nx, ny,-1, 0]
          elsif dx == 1 && dy == 0 # travel right
            beams << [nx, ny, 0, 1]
          elsif dx == -1 && dy == 0 # travel left
            beams << [nx, ny, 0,-1]
          else
            raise "Unexpected direction: #{dx}, #{dy} at #{new_pos}"
          end
        when nil
          next
        else
          raise "Unexpected Cell Value: #{cell} at #{new_pos}"
        end
      end

      # puts "Grid:\n#{grid.render}" if @debug
      # puts "BeamMap:\n#{render_grid}" if @debug

      return @beam_map.keys.count
    end

    def max_energized
      # reset beam_map
      max = 0
      #   v v v
      # > . . . <
      # > . . . <
      # > . . . <
      #   ^ ^ ^
      starting_positions = []
      @grid.width.times do |x|
        starting_positions << [x, -1, 0, 1]
        starting_positions << [x, @grid.height, 0, -1]
      end
      @grid.height.times do |y|
        starting_positions << [-1, y, 1, 0]
        starting_positions << [@grid.width, y, -1, 0]
      end

      starting_positions.each do |s|
        @beam_map = {}
        e = energize(s)
        max = e if e > max
      end

      max
    end
  end
end
