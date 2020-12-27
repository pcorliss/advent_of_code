require 'set'

module Advent

  class Bus
    attr_reader :bus, :start, :bus_with_offset

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
    def contest_match?(t, bus_offsets = @bus_with_offset)
      # puts "Checking #{t} #{bus_offsets}"
      bus_offsets.all? do |b, idx|
        # puts "#{t} #{idx} #{b} (#{t + idx} % #{b} == 0)"
        (t + idx) % b == 0
      end
    end

    # Use the largest number instead of the first number. Should speed up by a factor of 55 based on input
    # Chinese Remainder Theorem is what folks online are saying may be necessary.
    # Should be able to find solutons using two largest numbers, which will then repeat.
    # Far too slow to solve the full input. Use contest_prime instead
    def x_contest
      mult = @bus.max
      offset = @bus_with_offset[mult]
      i = 0
      while true do
        t = mult * i - offset
        return t if contest_match?(t)
        i += 1
        puts "T: #{t} I: #{i}" if i % 1_000_000 == 0
      end
    end

    def contest
      contest_prime(@bus_with_offset)
    end

    # The following hint ended up being key
    # The solution to a subset of the problem can be the starting point
    # The LCM (a * b * ...) can be the multiple we check with
    # The base case is just a single number
    # The solution for the full input is less than 2000 checks but more than 200 and returns quickly
    # http://mathforum.org/library/drmath/view/75030.html
    def contest_prime(bus_offsets)
      # puts "Off: #{bus_offsets}"
      return bus_offsets.first[0] - bus_offsets.first[1] if bus_offsets.length <= 1

      sorted_keys = bus_offsets.keys.sort
      # puts "Keys: #{sorted_keys}"
      sorted_keys.shift
      # puts "shift: #{sorted_keys}"

      start = contest_prime(bus_offsets.slice(*sorted_keys))
      # puts "Start: #{start}"
      lcm = sorted_keys.inject(:*)
      # puts "LCM: #{lcm}"

      i = 0
      t = start
      while true do
        return t if contest_match?(t, bus_offsets)
        t += lcm
        i += 1
        raise "Too many interations" if i > 2000
      end
    end
  end
end
