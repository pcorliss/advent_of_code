require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Trampoline
    attr_accessor :debug
    attr_reader :jumps, :pos

    def initialize(input)
      @debug = false
      @jumps = input.lines.map(&:to_i)
      @pos = 0
    end

    def debug!
      @debug = true
    end

    def step!(dec = false)
      jump = @jumps[@pos]
      @jumps[@pos] += 1
      @jumps[@pos] -= 2 if dec && jump >= 3
      @pos += jump
    end

    def exit?
      @pos >= @jumps.length
    end

    def run!(dec = false)
      steps = 0
      until exit? do
        step!(dec)
        steps += 1
      end
      steps
    end
  end
end
