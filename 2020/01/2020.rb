require 'set'

module Advent
  class One
    def initialize(input)
      @input = Set.new input.lines.map {|l| l.to_i}
    end

    # Initially this was going to be an exhaustive search but we know what number compliments any other number by just subtracting it from 2020.
    # The set makes this easier as we can search for a number in constant time from a larger list.
    # There's a potential issue where duplicates might be handled poorly
    def sum
      @input.each do |num|
        potential_match = 2020 - num
        if @input.include?(potential_match)
          return [num, potential_match]
        end
      end
      raise "Failed to find valid pair in input"
    end

    def mult
      sum.inject(:*)
    end

    # We've still got our set, but we'll need to exclude a number to prevent issues with duplicates
    # Could do something with sorted lists where we could do binary searches for numbers that would be less than another number
    # Or we could just add another loop to our search...
    # Could possibly precompute on insertion what the compliments would be
    # That would be faster for the two part case as we could short-circuit on read but at the expense of more memory usage.
    def triple_sum
      @input.each do |a|
        double_sum = 2020 - a
        @input.each do |b|
          c = double_sum - b
          if @input.include? c
            return [a, b, c]
          end
        end
      end

      raise "Failed to find valid triplet in input"
    end

    def triple_mult
      triple_sum.inject(:*)
    end
  end
end
