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
      @previous_states = Set.new
      @previous_states.add [starting_location, Set.new]
      @key_counter = 0
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

    def move!
      @steps += 1


      new_paths = []
      @paths.each do |path|
        @grid.neighbors(path[:pos]).each do |cell, val|
          next if val == '#'
          # create a position + keys hash, if it has been reached already prune the path
          next if val.match(/^[A-Z]$/) && !path[:keys].include?(val.downcase)
          next if @previous_states.include? [cell, path[:keys]]

          @previous_states.add([cell, path[:keys]])
          k = path[:keys]
          if val.match(/^[a-z]$/) && !k.include?(val)
            k = k.clone.add(val)
            @key_counter = k.count if k.count > @key_counter
          end

          new_paths << {
            pos: cell,
            keys: k,
          }
        end
      end

      # binding.pry if @debug
      # puts "Paths: #{new_paths}" if @debug
      @paths = new_paths
    end

    def finished?
      @key_counter >= keys.count
    end

    def steps_until_finished
      until finished? do
        move!
        puts "Step: #{@steps} - Paths: #{@paths.count} - Keys: #{@key_counter}/#{keys.count}" if @debug
      end
      @steps
    end
  end

  class MultiMaze
    attr_accessor :debug
    attr_reader :grid, :steps, :paths

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @steps = 0
      # @paths = [{
      #   pos: starting_location,
      #   visited: Set.new([starting_location]),
      #   keys: Set.new,
      # }]
      @previous_states = Set.new
      # @previous_states.add [starting_location, Set.new]
      @key_counter = 0
    end

    def starting_locations
      @grid.find_all('@')
    end

    def keys
      @keys ||= Set.new @grid.cells.values.uniq.select { |v| v.match(/[a-z]/) }
    end

    def debug!
      @debug = true
    end

    def move!
    end

    def map
      map = {}
      starting_locations.each_with_index do |start, idx|
        map[idx] = {}
        paths = [{
          pos: start,
          keys: Set.new,
          requirements: Set.new,
          visited: Set.new([start]),
          start: idx,
        }]
        steps = 0
        until paths.empty? do
          new_paths = []
          steps += 1
          paths.each do |path|
            @grid.neighbors(path[:pos]).each do |cell, val|
              # prune
              next if val == '#'
              next if path[:visited].include? cell

              # add keys/requirements/mappings
              k = path[:keys]
              r = path[:requirements]
              visited = path[:visited].clone.add cell

              if ('a'..'z').include? val
                k = k.clone.add val
                begin
                if map[path[:start]][val].nil?
                  map[path[:start]][val] = {
                    distance: path[:visited].count,
                    requirements: r.clone,
                  }
                end
                rescue => e
                  binding.pry if @debug
                  raise e
                end
                if !map[val] # We've never seen this value before so we'll start a new path from it
                  map[val] ||= {}
                  new_paths << {
                    pos: cell,
                    keys: Set.new([val]),
                    requirements: Set.new,
                    visited: Set.new([cell]),
                    start: val,
                  }
                end
              end
              if ('A'..'Z').include? val
                r = r.clone.add val
              end

              # construct new path
              new_paths << {
                pos: cell,
                keys: k,
                requirements: r,
                visited: visited,
                start: path[:start],
              }
            end
          end
          paths = new_paths
          puts "Step: #{steps} - Paths: #{paths.count}" if @debug
        end
      end
      map
    end

    def finished?
      @key_counter >= keys.count
    end

    def steps_until_finished
      until finished? do
        move!
        puts "Step: #{@steps} - Paths: #{@paths.count} - Keys: #{@key_counter}/#{keys.count}" if @debug
      end
      @steps
    end
  end

end
