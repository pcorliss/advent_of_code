#!/usr/bin/env ruby

require_relative 'lava'

input = File.read('./input.txt')

ad = Advent::Lava.new(input)
ad.debug!
ad.cube_state_counts

ad = Advent::Lava.new(input)
puts "Part 1: #{ad.exposed_sides}"
puts ad.interior_sides
ad.debug!
puts "Part 2: #{ad.exposed_sides - ad.interior_sides}"

# 1178. Too low - This was actually interior sides but should have been the difference
# 2186. Too high
# 1358 Too low - might have submitted the wrong answer
# 2006 was correct

ad.debug!
ad.cube_state_counts