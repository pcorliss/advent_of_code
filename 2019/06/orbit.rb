require 'set'

module Advent

  class Orbit
    attr_accessor :debug, :orbits, :reverse_orbits

    def initialize(input)
      @debug = false
      @orbits = {}
      @reverse_orbits = {}
      @orbit_count = {}
      input.each_line do |line|
        line.chomp!
        a, b = line.split(')')
        @orbits[a] ||= []
        @orbits[a] << b
        @reverse_orbits[b] = a
      end
    end

    def debug!
      @debug = true
    end

    def count_orbits(orb)
      return @orbit_count[orb] if @orbit_count[orb]
      count = 0
      if @reverse_orbits[orb]
        count += 1
        count += count_orbits(@reverse_orbits[orb])
      end
      @orbit_count[orb] = count
      count
    end

    def ancestors(orb)
      anc = []
      current_orb = orb
      until current_orb == "COM" do
        anc << @reverse_orbits[current_orb]
        current_orb = anc.last
      end
      anc.reverse
    end

    def nearest_common_ancestor(a, b)
      # puts "Ancestors: #{ancestors(a)}" if @debug
      # puts "Ancestors: #{ancestors(b)}" if @debug
      # binding.pry if @debug
      (ancestors(a) & ancestors(b)).last
    end

    def transfers_between_you_and_santa
      you_orbit = @reverse_orbits["YOU"]
      santa_orbit = @reverse_orbits["SAN"]
      ancestor = nearest_common_ancestor(you_orbit, santa_orbit)
      count_orbits(you_orbit) - count_orbits(ancestor) + count_orbits(santa_orbit) - count_orbits(ancestor)
    end
  end
end
