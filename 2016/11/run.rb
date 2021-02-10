#!/usr/bin/env ruby

require_relative 'rad'

input = File.read('./input-part2.txt')

ad = Advent::Rad.new(input)
ad.debug!
steps = ad.find_solution
puts "Steps: #{steps}"
