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
      input.each_line do |line|
        if line =~ /^(\w+):\s+([\d\s]+)$/ or raise "Bad line: #{line}"
          case $1
          when "Time"
            times = $2.split.map(&:to_i)
          when "Distance"
            records = $2.split.map(&:to_i)
          end
        end
      end

      times.zip(records).each do |time, record|
        @races << Race.new(time, record)
      end
    end

    def debug!
      @debug = true
    end

    def number_of_ways(race)
      (1...race.time).count do |t|
        (race.time - t) * t > race.record
      end
    end

    def number_of_ways_product
      @races.map do |race|
        number_of_ways(race)
      end.reduce(:*)
    end
  end
end
