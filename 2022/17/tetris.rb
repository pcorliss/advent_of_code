require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Tetris
    attr_accessor :debug
    attr_reader :jets, :jet_pos, :rock_pos, :grid, :current_rock

    ROCKS = [
      [[0,0],[1,0],[2,0],[3,0]],        #.####

      [[1,0],[0,1],[1,1],[2,1],[1,2]],  # .#.
                                        # ###
                                        # .#.

      [[2,0],[2,1],[0,2],[1,2],[2,2]],  # ..#
                                        # ..#
                                        # ###

      [[0,0],[0,1],[0,2],[0,3]],        # #
                                        # #
                                        # #
                                        # #

      [[0,0],[1,0],[0,1],[1,1]],        # ##
                                        # ##
    ]

    LEFT_WALL = 0
    RIGHT_WALL = 8
    FLOOR = 0

    def initialize(input)
      @debug = false
      @jets = input.strip.chars.map(&:to_sym)
      @jet_pos = 0
      @rock_pos = 0
      @grid = Grid.new
    end

    def debug!
      @debug = true
    end

    def get_next_jet
      j = @jets[@jet_pos]
      @jet_pos += 1
      @jet_pos %= @jets.count
      j
    end

    # TODO gsub to idx
    def get_next_rock
      r = ROCKS[@rock_pos]
      @rock_pos += 1
      @rock_pos %= ROCKS.count
      r
    end

    def add_rock!
      @current_rock = get_next_rock
      left = @current_rock.map(&:first).min # 0
      bottom = @current_rock.map(&:last).max # 2
      delta_x = LEFT_WALL + 3
      highest_rock = @grid.find_all('#').map(&:last).min || FLOOR
      delta_y = highest_rock - (4 + bottom)

      @current_rock = @current_rock.map do |x, y|
        [x + delta_x, y + delta_y]
      end
    end

    def rock_fall!
      delta_x = get_next_jet == :> ? 1 : -1
      delta_y = 1

      new_x_coords = @current_rock.map do |x, y|
        [x + delta_x, y]
      end

      min_x, max_x = new_x_coords.map(&:first).minmax
      if min_x <= 0 || max_x >= RIGHT_WALL
        puts "Wall Collision!" if @debug
        delta_x = 0
      end

      collision = new_x_coords.any? do |coord|
        @grid[coord] == '#'
      end

      puts "Block Collision!" if @debug && collision

      delta_x = 0 if collision

      new_max_y = delta_y + @current_rock.map(&:last).max

      solidify = false
      if new_max_y >= FLOOR
        puts "Floor Collision!" if @debug
        delta_y = 0
        solidify = true
      end

      new_xy_coords = @current_rock.map do |x, y|
        [x + delta_x, y + delta_y]
      end

      collision = new_xy_coords.any? do |coord|
        @grid[coord] == '#'
      end

      if collision
        puts "Downward Collision!" if @debug
        delta_y = 0
        solidify = true
      end

      @current_rock = @current_rock.map do |x, y|
        [x + delta_x, y + delta_y]
      end

      if solidify
        @current_rock.each do |cell|
          @grid[cell] = '#'
        end
        add_rock!
      end

      return [delta_x, delta_y, solidify]
    end

    def rock!
      add_rock! unless current_rock
      done = false
      until done do
        x, x, done = rock_fall!
      end
    end

    def tower_height
      grid.cells.keys.map(&:last).min.abs
    end
  end
end
