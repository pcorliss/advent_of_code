require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Nbody
    attr_accessor :debug
    attr_reader :moons

    def initialize(input)
      @debug = false
      @moons = input.lines.map do |l|
        Advent::Moon.new(l.chomp)
      end
      @states = Set.new
    end

    def step!
      @states.add @moons.map(&:hash)
      @moons.each do |moon_a|
        @moons.each do |moon_b|
          next if moon_a == moon_b
          3.times.each do |idx|
            if moon_a.pos[idx] > moon_b.pos[idx]
              moon_a.velocity[idx] -= 1
            elsif moon_a.pos[idx] < moon_b.pos[idx]
              moon_a.velocity[idx] += 1
            end
          end
        end
      end

      @moons.each do |moon|
        moon.pos.each_with_index do |axis, idx|
          moon.pos[idx] += moon.velocity[idx]
        end
      end
    end

    def debug!
      @debug = true
    end

    def previous_state?
      @states.include? @moons.map(&:hash)
    end
  end

  class Moon
    attr_reader :pos
    attr_accessor :velocity

    AXIS_MAP = {
    'x' => 0,
    'y' => 1,
    'z' => 2
    }

    def initialize(input)
      @debug = false
      @pos = [0,0,0]
      @velocity = [0,0,0]
      input.scan(/(x|y|z)=([\-\d]+)/).each do |axis, val|
        @pos[AXIS_MAP[axis]] = val.to_i
      end
    end

    # A moon's kinetic energy is the sum of the absolute values of its velocity coordinates.
    def kinetic_energy
      @pos.map(&:abs).sum
    end

    # A moon's potential energy is the sum of the absolute values of its x, y, and z position coordinates.
    def potential_energy
      @velocity.map(&:abs).sum
    end

    def energy
      kinetic_energy * potential_energy
    end

    def hash
      [@pos,@velocity].hash
    end
  end
end
