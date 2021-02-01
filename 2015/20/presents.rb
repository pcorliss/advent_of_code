require 'set'
require '../lib/grid.rb'
require 'prime'

module Advent

  class Presents
    attr_accessor :debug

    def initialize(input = nil)
      @debug = false
    end

    def debug!
      @debug = true
    end

    # Refactor to quickly return all factors instead
    def presents(house, mult = 10, filter=nil)
      # Sourced: https://stackoverflow.com/questions/3398159/all-factors-of-a-given-number
      1.upto(Math.sqrt(house)).select {|i| (house % i).zero?}.inject(0) do |acc, i|
        a = i
        b = house / i

        if filter
          acc += a*mult if b <= filter
          acc += b*mult if a != b && a <= filter
        else
          acc += a*mult
          acc += b*mult if a != b
        end
        acc
      end
    end

    def find_house(presents)
      i = 1
      loop do
        return i if presents(i) >= presents
        i += 1
        raise "Too many iterations!!! #{i}" if i > 100_000
      end
    end

    def find_house_prime(pres, mult = 10, filter = nil)
      largest = 0
      Prime.each do |i|
        # next if i % 10 != 1 || i % 10 != 9
        a = presents(i-1, mult, filter)
        b = presents(i+1, mult, filter)
        return i-1 if a >= pres
        return i+1 if b >= pres
        m = [a,b].max
        if m > largest
          puts "New Largest: #{m} #{i}" if @debug
          largest = m
        end
        raise "Too many iterations!!! #{i}" if i > 1_000_000
      end
    end
  end
end
