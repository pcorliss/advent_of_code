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
      @bus_with_offset = {}
      @bus_with_nil.each_with_index do |b, idx|
        @bus_with_offset[b] = idx unless b.nil?
      end
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

    # Use a smaller set with just busses and offsets, 5x speedup
    def contest_match?(t)
      @bus_with_offset.all? do |b, idx|
        if (t + idx) % b == 0
          true
        else
          false
        end
      end
    end

    # Use the largest number instead of the first number. Should speed up by a factor of 55 based on input
    # Chinese Remainder Theorem is what folks online are saying may be necessary.
    # Should be able to find solutons using two largest numbers, which will then repeat.
    def contest
      mult = @bus.max
      offset = @bus_with_nil.index(mult)
      i = 0
      while true do
        t = mult * i - offset
        return t if contest_match?(t)
        i += 1
        puts "T: #{t} I: #{i}" if i % 1_000_000 == 0
      end
    end
  end
end
