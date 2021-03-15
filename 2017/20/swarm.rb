require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require 'deep_clone'

module Advent

  class Swarm
    attr_accessor :debug
    attr_reader :particles

    def extract(str)
      _, nums, _ = str.split(/[\<\>]/)
      nums.split(',').map(&:to_i)
    end

    def initialize(input)
      @debug = false
      @particles = input.each_line.map do |line|
        line.chomp!
        p, v, a = line.split(', ')
        [extract(p), extract(v), extract(a)]
      end
    end

    def debug!
      @debug = true
    end

    POS = 0
    VEL = 1
    ACC = 2
    X = 0
    Y = 1
    Z = 2

    def closest_long_term
      min_idx = -1
      min_acc = nil
      @particles.each_with_index do |part, idx|
        vel_sum =
          (part[VEL][X].abs + part[ACC][X].abs * 100_000_000) +
          (part[VEL][Y].abs + part[ACC][Y].abs * 100_000_000) +
          (part[VEL][Z].abs + part[ACC][Z].abs * 100_000_000)
        if min_acc.nil? || vel_sum < min_acc
          min_idx = idx
          min_acc = vel_sum
        end
      end
      min_idx
    end

    def collision
      collisions = Set.new
      parts = DeepClone.clone @particles
      l = parts.length

      steps = 0
      steps_since_collision = 0
      while steps_since_collision < 10_000 do
        pos_map = {}
        i = 0
        # puts "Step: #{steps}" if @debug
        while i < l do
          if collisions.include? i
            i += 1
            next
          end
          p = parts[i]
          p[VEL][X] += p[ACC][X]
          p[VEL][Y] += p[ACC][Y]
          p[VEL][Z] += p[ACC][Z]
          p[POS][X] += p[VEL][X]
          p[POS][Y] += p[VEL][Y]
          p[POS][Z] += p[VEL][Z]
          if pos_map.has_key? p[POS]
            collisions.add i
            collisions.add pos_map[p[POS]]
            steps_since_collision = 0
          else
            pos_map[p[POS]] = i
          end
          i += 1
        end
        steps += 1
        steps_since_collision += 1
        puts "Steps Since Collision: #{steps_since_collision} Total Steps: #{steps} Collision Count: #{collisions.count} Remaining Particles: #{l - collisions.count}" if @debug && steps_since_collision < 2
      end

      collisions
    end
  end
end
