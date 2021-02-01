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
    def presents(house)
      acc = house * 10
      (1..(house/2)).each do |n|
        if house % n == 0
          acc += n * 10
        end
      end

      acc
    end

    def find_house(presents)
      i = 1
      loop do
        return i if presents(i) >= presents
        i += 1
        raise "Too many iterations!!! #{i}" if i > 100_000
      end
    end

    def find_house_prime(pres)
      largest = 0
      Prime.each do |i|
        # next if i % 10 != 1 || i % 10 != 9
        a = presents(i-1)
        b = presents(i+1)
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
