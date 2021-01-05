require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Maze
    attr_accessor :debug
    attr_reader :grid, :steps, :paths

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @steps = 0
      @paths = [{
        pos: starting_location,
        visited: Set.new([starting_location]),
        keys: Set.new,
      }]
    end

    # solver could be a breadth first algo with many paths
    # visited grid could exist per path and contain a set of keys as a value
      # if the set of keys is bigger overwrite
      # if not don't follow that path

    def starting_location
      @grid.find('@')
    end

    def keys
      @keys ||= Set.new @grid.cells.values.uniq.select { |v| v.match(/[a-z]/) }
    end

    def debug!
      @debug = true
    end

    DIRECTIONS = [
      [ 0,-1], # North
      [ 0, 1], # South
      [-1, 0], # West
      [ 1, 0], # East
    ]

    def move!
      @steps += 1

      new_paths = []
      @paths.each do |path|
        @grid.neighbors(path[:pos]).each do |cell, val|
          next if val == '#'
          next if path[:visited].include? cell
          if val.match(/[A-Z]/)
            next unless path[:keys].include?(val.downcase)
          end
          keys = path[:keys]
          visited = nil
          if val.match(/[a-z]/)
            keys = keys.clone.add(val) 
            visited = Set.new()
          end
          visited ||= path[:visited].clone
          new_paths << {
            pos: cell,
            keys: keys,
            visited: visited.add(cell),
          }
        end
      end

      # binding.pry if @debug
      puts "Paths: #{new_paths}" if @debug
      @paths = new_paths
    end

    def finished?
      @paths.any? do |path|
        path[:keys] == keys
      end
    end

    def steps_until_finished
      until finished? || @steps > 150 do
        move!
      end
      @steps
    end
  end
end
