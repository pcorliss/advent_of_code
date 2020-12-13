require 'set'

module Advent

  class Bus
    attr_reader :bus, :start

    def initialize(input)
      @start = input.lines.first.chomp.to_i
      @bus_with_nil = input.lines[1].chomp.split(",").map do |b|
        if b == 'x'
          nil
        else
          b.to_i
        end
      end
      @bus = @bus_with_nil.compact
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

    def contest_match?(t)
      @bus_with_nil.each_with_index.all? do |b, idx|
        t_prime = t + idx
        if b.nil? || t_prime % b == 0
          true
        else
          false
        end
      end
    end

    def contest
      mult = @bus.first
      i = 0
      while true do
        t = mult * i
        return t if contest_match?(t)
        i += 1
        raise "Break!" if t > 10000000000
      end
    end
  end
end
