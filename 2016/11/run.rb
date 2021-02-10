#!/usr/bin/env ruby

require_relative 'rad'

input = File.read('./input.txt')

ad = Advent::Rad.new(input)
ad.debug!
# steps = ad.find_solution
steps = ad.find_solution_prime
puts "Steps: #{steps}"

input = File.read('./input-part2.txt')
ad = Advent::Rad.new(input)
ad.debug!
steps = ad.find_solution_prime
puts "Steps: #{steps}"
