require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Hex
    attr_accessor :debug
    attr_reader :steps

    def initialize(input)
      @debug = false
      @steps = input.chomp.split(',')
    end

    def debug!
      @debug = true
    end

    HEX_DIR = {
      'n'  => [ 0, 1,-1],
      's'  => [ 0,-1, 1],
      'ne' => [ 1, 0,-1],
      'sw' => [-1, 0, 1],
      'nw' => [-1, 1, 0],
      'se' => [ 1,-1, 0],
    }
    X = 0
    Y = 1
    Z = 2

    def follow_path(steps)
      pos = [0,0,0]
      steps.each do |step|
        x, y, z = HEX_DIR[step]
        pos[X] += x
        pos[Y] += y
        pos[Z] += z
      end
      pos
    end

    def distance(pos)
      pos.map(&:abs).max
    end
  end
end
