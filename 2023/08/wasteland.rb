require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Wasteland
    attr_accessor :debug
    attr_reader :directions, :mapping

    def initialize(input)
      @debug = false
      lines = input.lines
      direction_line = input.lines.shift
      @directions = direction_line.chomp.split('').map(&:to_sym)
      @mapping = {}
      lines.each do |line|
        if line =~ /^(\w+) = \((\w+), (\w+)\)$/
          key = $1.to_sym
          @mapping[key] = [$2.to_sym, $3.to_sym]
        end
      end
    end

    def debug!
      @debug = true
    end

    def steps
      count = 0
      current = :AAA
      until current == :ZZZ do
        dir = @directions[count % @directions.length]
        count += 1
        current = @mapping[current][dir == :L ? 0 : 1]
      end
      count
    end

    # Non-optimized quick LCM
    # def lcm(counts)
    #   largest = counts.max
    #   sums = counts.dup
    #   current = largest
    #   until sums.all? { |s| current % s == 0} do
    #     current += largest
    #   end
    #   current
    # end

    # Efficient LCM for array of numbers
    def lcm(counts)
      counts.reduce(1, :lcm)
    end

    def ghost_steps
      count = 0
      start_points = @mapping.keys.select { |k| k.end_with?('A')}
      end_points = @mapping.keys.select { |k| k.end_with?('Z')}.to_set
      current_points = start_points
      end_point_count = []
      until false do #current_points.to_set == end_points do
        current_points.each_with_index do |current, idx|
          if current.end_with?('Z')
            end_point_count[idx] ||= []
            end_point_count[idx] << count
          end
        end

        if end_point_count.compact.length >= current_points.length && end_point_count.all? { |points| points.length > 1 }
          puts "Reached a cycle!" if @debug
          puts "End Point Cycles: #{end_point_count}" if @debug
          cycle_distance = end_point_count.map {|cycles| a, b = cycles.last(2); b - a }
          puts "Cycle Distances: #{cycle_distance}" if @debug
          return lcm(cycle_distance)
        end

        dir = @directions[count % @directions.length]
        count += 1
        current_points = current_points.map do |current|
          @mapping[current][dir == :L ? 0 : 1]
        end.to_set

      end

      count
    end
  end
end
