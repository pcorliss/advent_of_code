require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Almanac
    attr_accessor :debug
    attr_reader :seeds, :maps

    def initialize(input)
      @debug = false
      @maps = {}
      current_map = nil
      input.each_line do |line|
        if line =~ /^(.*) map:/
          current_map = $1
          @maps[current_map] = []
        elsif line =~ /seeds: (.*)$/
          @seeds = $1.split.map(&:to_i)
        elsif line =~ /\d+/
          @maps[current_map] << line.strip.split.map(&:to_i)
        end
      end
    end

    def debug!
      @debug = true
    end

    def map_value(source, destination, value)
      map = @maps["#{source}-to-#{destination}"]
      raise "Unable to find map for #{source}-to-#{destination}" unless map
      map.each do |dest_range, source_range, size|
        if (source_range...(source_range + size)).include?(value)
          return (value - source_range) + dest_range
        end
      end

      return value
    end

    def seed_to_location(seed)
      current = 'seed'
      end_map = 'location'
      val = seed

      until current == end_map do
        dest = nil
        @maps.keys.each do |k|
          if k.start_with?(current)
            x, dest = k.split('-to-')
            break
          end
        end

        raise "No Destination found for #{current}" unless dest

        val = map_value(current, dest, val)
        current = dest
      end

      val
    end

    def lowest_location
      @seeds.map { |s| seed_to_location(s) }.min
    end
  end
end
