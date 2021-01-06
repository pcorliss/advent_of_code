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
      return @map if @map
      @map = {}
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
                r = r.clone.add val.downcase
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

    def bfs
      paths = []
      paths << {
        pos: 4.times.to_a,
        keys: Set.new,
        steps: [],
        distance: 0,
      }

      best = nil
      best_distance = 0
      # Could sort the paths by distance continously and pop off a queue
      # That way we don't waste time with very long paths
      i = 0
      until paths.empty? do
        # puts "Paths: #{paths.count} #{best_distance}" if @debug
        paths.sort_by! {|p| p[:distance] }
        path = paths.shift
        puts "#{i} #{paths.count}  Path: #{path[:distance]} #{path}" if @debug && i % 1000 == 0
        path[:pos].each_with_index do |start, quad|
          # puts "\tQuad: #{quad} Start: #{start}" if @debug
          connections = map[path[:pos][quad]]
          # puts "\t\tConnections: #{connections}" if @debug
          connections.each do |dest, details|
            # puts "\t\t\tDest: #{dest.inspect} #{details}" if @debug
            # prune
            # We don't yet have the needed keys to visit this node
            # binding.pry if @debug && path[:pos][0] == 'a' && quad == 3
            next if path[:keys].include? dest
            next unless (details[:requirements] - path[:keys]).empty?
            # puts "\t\t\tPassed Requirements: #{details[:requirements]} - #{path[:keys]}" if @debug
            # Why bother exploring a path that takes longer than our best
            distance = path[:distance] + details[:distance]
            next if best && distance >= best_distance
            # puts "\t\t\tPassed Best Distance Check" if @debug

            steps = path[:steps] + [[start,dest,details[:distance]]]
            k = path[:keys].clone.add(dest)
            pos = path[:pos].clone
            pos[quad] = dest

            # test finished
            if k.count >= keys.count
              puts "Found Solution: #{distance} #{steps}" if @debug
              if best.nil? || distance < best_distance
                best = steps
                best_distance = distance
                puts "\tNew Best!!" if @debug
              end
            end

            # new paths
            paths << {
              pos: pos,
              keys: k,
              steps: steps,
              distance: distance,
            }
          end
        end
        i += 1
      end
      best
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
