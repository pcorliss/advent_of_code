require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Towers
    attr_accessor :debug
    attr_reader :towers, :descendants, :parent

    TOWER_REGEX = /^(\w+) \((\d+)\)/
    def initialize(input)
      @debug = false
      @towers = {}
      @descendants = {}
      @parent = {}
      input.each_line do |line|
        line.chomp!
        if line =~ /^(\w+) \((\d+)\)/
          name = $1
          weight = $2.to_i
          @towers[name] = weight
          _, descendants = line.split('-> ')
          if descendants
            @descendants[name] = descendants.split(', ')
            @descendants[name].each do |desc|
              @parent[desc] = name
            end
          else
            @descendants[name] = []
          end
        end
      end
    end

    def debug!
      @debug = true
    end

    def bottom
      @towers.each do |node, weight|
        return node unless @parent.has_key?(node)
      end
      nil
    end
  end
end
