require 'set'

module Advent

  class Bus
    attr_reader :bus, :start

    def initialize(input)
      @start = input.lines.first.chomp.to_i
      @bus = input.lines[1].chomp.split(",").map do |b|
        if b == 'x'
          nil
        else
          b.to_i
        end
      end.compact
    end

    def time_until_arrival(b)
      b - (@start % b)
    end

    def earliest_bus
      acc = []
      @bus.each do |b|
        t = time_until_arrival(b)
        if acc.empty? || acc[1] > t
          acc = [b, t]
        end
      end
      acc
    end
  end
end
