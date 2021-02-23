require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Hvac
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
    end

    def debug!
      @debug = true
    end

    def starting
      @grid.find('0')
    end

    def locations
      @grid.cells.find_all do |cell, val|
        val =~ /\d/
      end.to_h
    end

    def map
      return @map if @map
      @map = {}

      key_count = locations.count
      visited = {}

      paths = locations.map do |pos, start|
        @map[start] ||= {}
        visited[start] = Set.new([pos])
        [pos, start]
      end

      steps = 0
      until paths.empty? do
        steps +=1
        new_paths = []
        puts "#{steps} - #{paths.count} - Sample: #{paths.first}" if @debug
        paths.each do |path|
          pos, start = path
          next if @map[start].count >= key_count - 1

          @grid.neighbors(pos).each do |n_pos, val|
            next if val == '#'
            next if visited[start].include? n_pos
            # puts "#{steps} - #{start} - #{n_pos} - #{val}" if @debug && start == '4'

            if val =~ /\d/
              # puts "Found: #{val} for #{start} in #{steps} #{@map}" if @debug && (start == '4' && val =='1') || (start == '1' && val == '4')
              # next if @map[start][val]
              @map[start][val] ||= steps
              @map[val][start] ||= steps
            end

            visited[start].add n_pos
            new_paths << [n_pos, start]
          end
        end
        paths = new_paths
      end

      @map
    end

    def steps_from_path(path)
      sum = 0
      (1..path.length-1).each do |i|
        start = path[i-1]
        targ = path[i]
        sum += map[start][targ]
      end
      sum
    end

    def fewest_steps(return_to_origin = false)
      start = '0'
      targets = locations.values - [start]
      shortest = targets.permutation.min_by do |perm|
        test_path = [start] + perm
        test_path << start if return_to_origin
        steps_from_path(test_path)
      end
      path = [start] + shortest
      path << start if return_to_origin
      path
    end
  end
end
