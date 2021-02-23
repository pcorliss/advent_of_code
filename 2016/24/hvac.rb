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

            if val =~ /\d/
              next if @map[start][val]
              @map[start][val] ||= steps
              @map[val][start] ||= steps
              puts "Found: #{val} for #{start} in #{steps} #{@map}" if @debug
            end

            visited[start].add n_pos
            new_paths << [n_pos, start]
          end
        end
        paths = new_paths
      end

      @map
    end
  end
end
