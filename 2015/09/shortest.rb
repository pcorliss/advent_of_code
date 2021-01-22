require 'set'
require '../lib/grid.rb'

module Advent

  class Shortest
    attr_accessor :debug
    attr_reader :distance

    def initialize(input)
      @debug = false
      @distance = {}
      input.each_line do |line|
        line.chomp!
        routes, distance = line.split(" = ")
        a, b = routes.split(" to ")
        @distance[a] ||= {}
        @distance[b] ||= {}
        @distance[a][b] = distance.to_i
        @distance[b][a] = distance.to_i
      end
    end

    def debug!
      @debug = true
    end

    def calc_distance(path)
      dist = 0
      i = 0
      current_pos = path[i]
      while i < path.length-1 do
        i += 1
        next_pos = path[i]
        dist += @distance[current_pos][next_pos]
        current_pos = next_pos
      end
      dist
    end

    def shortest
      p = @distance.keys.permutation.min_by do |path|
        calc_distance(path)
      end
      {
        path: p,
        distance: calc_distance(p),
      }
    end

    def longest
      p = @distance.keys.permutation.max_by do |path|
        calc_distance(path)
      end
      {
        path: p,
        distance: calc_distance(p),
      }
    end
  end
end
