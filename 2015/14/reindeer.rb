require 'set'
require '../lib/grid.rb'

module Advent

  class Reindeer
    attr_accessor :debug
    attr_reader :reindeer

    REINDEER_REGEX = /^(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds.$/
    def initialize(input)
      @debug = false
      @reindeer = {}
      input.each_line do |line|
        line.chomp!
        # Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
        if line =~ REINDEER_REGEX
          name = $1
          speed = $2
          duration = $3
          rest = $4
          @reindeer[name] = {
            speed: speed.to_i,
            duration: duration.to_i,
            rest: rest.to_i,
          }
        end
      end
    end

    def debug!
      @debug = true
    end

    def distance(deer, total_duration)
      speed = @reindeer[deer][:speed]
      duration = @reindeer[deer][:duration]
      rest = @reindeer[deer][:rest]

      interval = duration + rest

      intervals = total_duration / interval
      interval_duration = intervals * duration

      partial = total_duration % interval
      partial_distance = [partial, duration].min

      (interval_duration + partial_distance) * speed
    end

    def winner(time)
      @reindeer.keys.max_by do |deer|
        distance(deer, time)
      end
    end

    def points(time)
      point_tally = {}

      time.times do |t|
        deer_distance_map = {}
        @reindeer.keys.each do |deer|
          deer_distance_map[deer] = distance(deer, t + 1)
        end
        puts "Distances: #{deer_distance_map}" if @debug
        max_distance = deer_distance_map.values.max
        puts "Max: #{max_distance}" if @debug
        leaders = deer_distance_map.select { |d, v| v == max_distance }.keys
        leaders.each do |d|
          point_tally[d] ||= 0
          point_tally[d] += 1
        end
      end

      point_tally
    end
  end
end
