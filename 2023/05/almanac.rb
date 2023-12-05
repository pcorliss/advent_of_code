require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Almanac
    attr_accessor :debug
    attr_reader :seeds, :maps, :map_map

    def initialize(input)
      @debug = false
      @maps = {}
      @map_map = {}
      current_map = nil
      input.each_line do |line|
        if line =~ /^(.*) map:/
          current_map = $1
          src, dest = current_map.split('-to-')
          @map_map[src] = dest
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
        dest = @map_map[current]

        raise "No Destination found for #{current}" unless dest

        val = map_value(current, dest, val)
        current = dest
      end

      val
    end

    def lowest_location
      @seeds.map { |s| seed_to_location(s) }.min
    end

    def lowest_location_2
      @seeds.each_slice(2).map do |seed, range|
        v = (seed...(seed+range)).min_by { |s| seed_to_location(s) }
        seed_to_location(v)
      end.min
    end

    # File activesupport/lib/active_support/core_ext/range/overlaps.rb, line 7
    def overlaps?(a, b)
      a.cover?(b.first) || b.cover?(a.first)
    end

    def new_ranges(start_ranges, maps)
      # Start: WWWWW  XXX YYY   ZZZ 
      #   Map:  D E  AAA   BBB CCCCC 
      #   Res: WDWEW  AAX YBB   CCC

      #Assuming there are no overlapping ranges in the maps, which is probably safe
      # We need to apply the map one at a time, and mutate the start ranges

      working_ranges = start_ranges.dup

      result_ranges = []

      maps.each do |dest_range, source_range, size|
        map_range = (source_range...(source_range + size))
        offset = dest_range - source_range
        new_result_ranges = []
        original_ranges = []

        working_ranges.each do |range|
          original_ranges << range and next unless overlaps?(range, map_range)

          if map_range.cover?(range)
            # map_range includes range entirely
            # We can map the whole range and do a 1:1 replacement
            original_ranges << ((range.min + offset)...(range.last + offset))
          elsif range.cover?(map_range)
            # range includes map range entirely
            # We'll need to make 1-3 new ranges
            if range.min < map_range.min
              original_ranges << (range.min...map_range.min)
            end

            new_result_ranges << ((map_range.min + offset)...(map_range.last + offset))

            if range.max > map_range.max
              original_ranges << (map_range.last...range.last)
            end
          elsif map_range.min < range.min
            # map_range is on the left side of the range
            # We'll need to make 2 new ranges
            new_result_ranges << ((range.min + offset)...(map_range.last + offset))
            original_ranges << (map_range.last...range.last)
          elsif map_range.min > range.min
            # map_range is on the right side of the range
            # We'll need to make 2 new ranges
            original_ranges << (range.min...map_range.min)
            new_result_ranges << ((map_range.min + offset)...(range.last + offset))
          end
        end
        working_ranges = original_ranges
        result_ranges.concat new_result_ranges
      end

      result_ranges.concat working_ranges

      return result_ranges
    end

    def collapse_ranges
      seed_ranges = @seeds.each_slice(2).map do |seed, range|
        (seed...(seed+range))
      end

      # puts "Ranges: #{seed_ranges.inspect}"

      current = 'seed'
      end_map = 'location'
      ranges = seed_ranges

      until current == end_map do
        dest = @map_map[current]

        raise "No Destination found for #{current}" unless dest

        ranges_to_apply = @maps["#{current}-to-#{dest}"]
        ranges = new_ranges(ranges, ranges_to_apply)
        applied_ranges = ranges_to_apply.map do |dest_range, source_range, size|
          map_range = (source_range...(source_range + size))
          offset = dest_range - source_range
          [map_range, offset]
        end
        puts "Apply : #{applied_ranges.inspect} #{current}-to-#{dest}" if @debug
        puts "Ranges: #{ranges.inspect}" if @debug
        current = dest
      end

      ranges
    end

    def lowest_location_optimized
      ranges = collapse_ranges
      ranges.min_by(&:min).min
    end


    # Seed 79,
    # soil 81,
    # fertilizer 81,
    # water 81,
    # light 74,
    # temperature 78,
    # humidity 78,
    # location 82.

    # Could work backwards from the locations upwards to seeds
    # Could try building an interval tree perhaps?
    # Could try collapsing the ranges into a direct mapping?
  end
end
