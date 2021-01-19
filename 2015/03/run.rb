#!/usr/bin/env ruby

require_relative 'sphere'

input = File.read('./input.txt')

ad = Advent::Sphere.new(input)
ad.trace!
puts "Houses Visited: #{ad.grid.cells.count}"
# 1794 was too low

ad = Advent::Sphere.new(input)
puts "Houses Visited: #{ad.robo_houses}"
# 4653 is too high
