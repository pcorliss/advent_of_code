require 'set'

module Advent
  class One
    def initialize(input)
      @input = Set.new input.lines.map {|l| l.to_i}
    end

    # Initially this was going to be an exhaustive search but we know what number compliments any other number by just subtracting it from 2020.
    # The set makes this easier as we can search for a number in constant time from a larger list.
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
  end
end
