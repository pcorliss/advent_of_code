require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Wait
    attr_accessor :debug
    attr_reader :races

    Race = Struct.new(:time, :record)

    def initialize(input)
      @debug = false
      @races = []
      times = nil
      records = nil
      last_race = Race.new
      input.each_line do |line|
        if line =~ /^(\w+):\s+([\d\s]+)$/ or raise "Bad line: #{line}"
          case $1
          when "Time"
            times = $2.split.map(&:to_i)
            last_race.time = $2.split.join.to_i
          when "Distance"
            records = $2.split.map(&:to_i)
            last_race.record = $2.split.join.to_i
          end
        end
      end

      times.zip(records).each do |time, record|
        @races << Race.new(time, record)
      end
      @races << last_race


    end

    def debug!
      @debug = true
    end

    def number_of_ways(race)
      # ways = (1...race.time).count do |t|
      #   (race.time - t) * t > race.record
      # end

      left_root =  (-race.time + Math.sqrt(race.time**2 - 4 * race.record)) / -2
      right_root = (-race.time - Math.sqrt(race.time**2 - 4 * race.record)) / -2
      quadratic = right_root.ceil - left_root.floor - 1

      # raise "Quad: #{quadratic} vs Counting: #{ways}. Left Root: #{left_root} Right Root: #{right_root}" if quadratic != ways

      quadratic
    end

    def number_of_ways_product
      @races[0..-2].map do |race|
        number_of_ways(race)
      end.reduce(:*)
    end
  end
end
