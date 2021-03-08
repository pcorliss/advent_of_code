require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Firewall
    attr_accessor :debug
    attr_reader :layers

    def initialize(input)
      @debug = false
      @layers = {}
      input.each_line do |line|
        line.chomp!
        layer, depth = line.split(': ')
        @layers[layer.to_i] = depth.to_i
      end
    end

    def debug!
      @debug = true
    end

    def cur_depth(layer, time)
      return -1 unless @layers.has_key? layer
      mod = (@layers[layer] - 1) * 2
      half_mod = mod / 2
      depth = time % mod
      if depth > half_mod
        depth = mod - depth
      end
      depth
    end

    def caught?(time)
      layer = time
      cur_depth(layer, time) == 0
    end

    def severity
      sev = 0
      @layers.each do |layer, depth|
        if caught?(layer)
          sev += layer * depth
        end
      end
      sev
    end
  end
end
