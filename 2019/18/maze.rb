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
            # Skip if key count is too low
            # This is about 33% faster and the sample cases work but not fast enough
            #next if k.count < @key_counter - 2
            ### skip if there's already another path with the same new keyset
            ### this is actually bad, because we can sometimes pick up a key while on the right path that may have been picked up  in another ill-fated path
            # next if new_paths.any? {|p| p[:keys] == keys }
          end

          new_paths << {
            pos: cell,
            keys: k,
          }
        end
      end

      # binding.pry if @debug
      puts "Paths: #{new_paths}" if @debug
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
end
