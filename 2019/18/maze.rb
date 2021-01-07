require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'
require 'bitset'

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
      return @keys if @keys

      @keys = Bitset.new(26)
      @keys.set(@grid.cells.values.uniq.select { |v| v.match(/[a-z]/) }.map {|char| char.ord - 97})
      @keys
    end

    def debug!
      @debug = true
    end

    def move!
    end

    def quad_requirements
      @quad_requirements ||= 4.times.map do |i|
        m = map[i][i]
        b = Bitset.new(26)
        m.each do |key, details|
          b = b | details[1]
        end
        b
      end
    end

    def map
      return @map if @map
      @map = {}
      starting_locations.each_with_index do |start, idx|
        map[idx] = {}
        map[idx][idx] = {}
        paths = [{
          pos: start,
          keys: Set.new,
          requirements: Bitset.new(26),
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
                if map[idx][path[:start]][val].nil?
                  map[idx][path[:start]][val] = [
                    path[:visited].count,
                    r.clone,
                  ]
                end
                if !map[idx][val] # We've never seen this value before so we'll start a new path from it
                  map[idx][val] ||= {}
                  new_paths << {
                    pos: cell,
                    keys: Set.new([val]),
                    requirements: Bitset.new(26),
                    visited: Set.new([cell]),
                    start: val,
                  }
                end
              end
              if ('A'..'Z').include? val
                r = r.clone
                r.set (val.downcase.ord - 97)
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
          # puts "#{idx} Step: #{steps} - Paths: #{paths.count}" if @debug
        end
      end
      map
    end

    def gen_paths(dist_paths, max_keys = keys)
      i = 0
      dist_paths.each do |path|
        puts "Paths: #{@paths.count}-#{dist_paths.count} Dist: #{path[:distance]} Keys: #{path[:keys].cardinality}" if @debug && i % 1000 == 0
        # binding.pry if path[:pos].nil? && @debug
        path[:pos].each_with_index do |start, quad|
          next unless start
          m = map[quad][start]
          m.each do |dest, details|
            next if path[:keys][dest.ord - 97]
            next unless (details[1] - path[:keys]).empty?
            distance = path[:distance] + details[0]
            next if @best && distance >= @best_distance

            k = path[:keys].clone
            k.set(dest.ord - 97)

            steps = path[:steps] + [[start,dest,details[0]]]
            pos = path[:pos].clone
            pos[quad] = dest

            if k == max_keys
              puts "Found Solution: #{distance} #{steps}" if @debug
              if @best.nil? || distance < @best_distance
                @best = steps
                @best_distance = distance
                @best_path = {
                  pos: pos,
                  keys: k,
                  steps: steps,
                  distance: distance,
                }
                puts "\tNew Best!!" if @debug
              end
              next
            end

            @paths[distance] ||= []
            @paths[distance] << {
              pos: pos,
              keys: k,
              steps: steps,
              distance: distance,
            }
          end
        end
        i += 1
      end
    end

    def bfs
      @paths = {0 => []}

      starting_pos = []
      quad_requirements.each_with_index do |req, idx|
        if req.empty?
          starting_pos[idx] = idx
        else
          starting_pos[idx] = nil
        end
      end

      max_keys = Bitset.new(26)
      starting_pos.each do |i|
        if i
          map[i][i].keys.each do |k|
            max_keys.set(k.ord - 97)
          end
        end
      end

      @paths[0] << {
        pos: starting_pos,
        keys: Bitset.new(26),
        steps: [],
        distance: 0,
      }

      @best = nil
      @best_distance = 0
      @best_path = nil
      last_distance = 0

      until @best do
        break if @paths.compact.empty?
        if @paths[last_distance].nil? || @paths[last_distance].empty?
          last_distance += 1
          next
        end

        dist_paths = @paths[last_distance]
        gen_paths(dist_paths, max_keys)

        @paths.delete(last_distance) if @paths[last_distance]
        last_distance += 1
      end

      positions = nil
      if @best_path
        positions = @best_path[:pos]
        positions.each_with_index do |pos, idx|
          if pos
            @best_path[:pos][idx] = nil
          else
            @best_path[:pos][idx] = idx
          end
        end

        @paths = {@best_distance => [@best_path]}
      else
        @paths = {
          0 => [
            pos: 4.times.to_a,
            keys: Bitset.new(26),
            steps: [],
            distance: 0,
          ]
        }
      end


      @best = nil
      @best_distance = 0
      @best_path = nil
      last_distance = 0

      until @best do
        if @paths[last_distance].nil? || @paths[last_distance].empty?
          last_distance += 1
          next
        end

        dist_paths = @paths[last_distance]
        gen_paths(dist_paths)

        @paths.delete(last_distance) if @paths[last_distance]
        last_distance += 1
      end
      @best
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
