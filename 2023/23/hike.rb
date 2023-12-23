require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Hike
    attr_accessor :debug
    attr_reader :grid, :start, :finish

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @start = [1,0]
      @grid.width.times do |x|
        y = @grid.height - 1
        if @grid[x,y] == '.'
          @finish = [x,y]
          break
        end
      end
    end

    def debug!
      @debug = true
    end

    SLOPES = {
      '>' => [1,0],
      '<' => [-1,0],
      '^' => [0,-1],
      'v' => [0,1],
    }

    def longest_hike
      # if you step onto a slope tile, your next step must be downhill (in the direction the arrow is pointing)
      # never step onto the same tile twice
      branches = [[@start, Set.new([[@start]])]]
      hikes = []
      i = 0
      until branches.empty? do
        new_branches = []
        branches.each do |branch|
          pos, path = branch
          if pos == @finish
            hikes << branch
            next
          end

          x,y = pos
          @grid.neighbors(pos).each do |(nx, ny), val|
            next if val == '#'
            next if path.include?([nx, ny])
            if SLOPES.keys.include?(val)
              dx = nx - x
              dy = ny - y
              next unless SLOPES[val] == [dx, dy]
            end
            npath = path.dup <<  [nx, ny]
            new_branches << [[nx, ny], npath]
          end
        end
        branches = new_branches
        i += 1
        raise "Too many iterations #{i}" if i > 10000
      end

      puts "Hikes: #{hikes.count}, #{hikes.map(&:last).map(&:length).sort}" if @debug
      hikes.map(&:last).map(&:length).max - 1
    end
  end
end
