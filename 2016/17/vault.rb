require 'set'
require '../lib/grid.rb'
require 'digest'

module Advent

  class Vault
    attr_accessor :debug
    attr_reader :pw

    def initialize(input)
      @debug = false
      @pw = input.chomp
      @md5 = Digest::MD5.new
    end

    def debug!
      @debug = true
    end

    OPEN_CHARS = Set.new(%w(b c d e f))
    DIRECTION_MAP = %w(U D L R)
    CARDINAL_DIRECTIONS = [
      [ 0,-1], # Up North
      [ 0, 1], # Down South
      [-1, 0], # Left West
      [ 1, 0], # Right East
    ]
    X = 0
    Y = 1
    TARGET = [3,3]

    # Snagged from Grid, had to reorder the cardinal directions to make things work
    def neighbor_coords(cell, diagonals = false)
      directions = CARDINAL_DIRECTIONS
      directions.map do |dir|
        [cell[X] + dir[X], cell[Y] + dir[Y]]
      end
    end

    # Stolen from day 14
    def md5(msg)
      @md5.reset
      @md5 << @pw
      @md5 << msg
      @md5.hexdigest
    end

    def interpret_hash(hash)
      hash[0...4].each_char.map do |char|
        OPEN_CHARS.include? char
      end
    end

    def available_directions(path)
      hash = md5(path.join)
      open_doors = []
      interpret_hash(hash).each_with_index do |open_door, idx|
        open_doors << DIRECTION_MAP[idx] if open_door
      end
      open_doors
    end

    def out_of_bounds?(pos)
      x, y = pos
      return true if x < 0 || y < 0
      return true if x > 3 || y > 3
      false
    end

    def reached_target?(pos)
      pos == TARGET
    end

    def pos(path)
      path.inject([0,0]) do |acc, dir|
        idx = DIRECTION_MAP.index(dir)
        x_delta, y_delta = CARDINAL_DIRECTIONS[idx]
        acc[X] += x_delta
        acc[Y] += y_delta
        acc
      end
    end

    def find_path(return_on_target = true)
      paths = [[]]
      steps = 0
      successes = []
      while steps < 1000 do
        new_paths = []
        puts "Steps: #{steps} - Possible Paths: #{paths.count}" if @debug
        return successes if paths.count.zero?
        paths.each do |path|
          available_directions(path).each do |dir|
            new_path = path.clone
            new_path << dir
            new_pos = pos(new_path)

            next if out_of_bounds?(new_pos)
            if reached_target?(new_pos)
              return new_path.join if return_on_target
              successes << new_path.join
              next
            end

            new_paths <<  new_path
          end
          # Prune Possibles
        end
        paths = new_paths
        steps += 1
      end
      raise "Too many iterations!!!"
    end
  end
end
