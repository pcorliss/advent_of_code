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

    def caught?(layer, time)
      cur_depth(layer, time) == 0
    end

    def severity(offset = 0)
      sev = 0
      @layers.each do |layer, depth|
        if caught?(layer, layer + offset)
          sev += layer * depth
        end
      end
      sev
    end

    def find_stealth_offset
      offset = 0
      loop do
        offset += 1
        return offset if @layers.all? { |layer, depth| !caught?(layer, layer + offset) }
        puts "#{offset}" if @debug && offset % 100_000 == 0
        raise "Too many iterations" if offset > 10_000_000
      end
    end
  end
end
