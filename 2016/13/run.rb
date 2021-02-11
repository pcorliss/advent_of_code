#!/usr/bin/env ruby

require_relative 'maze'

input = File.read('./input.txt')

ad = Advent::Maze.new(input)
s = ad.steps([31,39])
puts "Steps: #{s}"

ad.debug!
s = ad.steps([31,39], 50)
puts "Locations: #{s}"

# 473 is too high - Did we include 1,1?
# Off by one?a
#
# 460 is too high
# 448 is too high
#
# Probably need to exclude walls
# 217 isn't right... off by one?
