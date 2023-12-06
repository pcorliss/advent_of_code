#!/usr/bin/env ruby

require_relative 'wait'

input = File.read('./input.txt')

ad = Advent::Wait.new(input)
puts "Product of number of ways to win: #{ad.number_of_ways_product}"
puts "number of ways to win part 2: #{ad.number_of_ways(ad.races.last)}"
# Unoptimized this only takes a few seconds, 2.94s
# Reworked to use the quadratic fomula and it takes 0.04s