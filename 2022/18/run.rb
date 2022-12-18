#!/usr/bin/env ruby

require_relative 'lava'

input = File.read('./input.txt')

ad = Advent::Lava.new(input)
puts ad.exposed_sides
# ad.debug!
puts ad.interior_sides
puts ad.exposed_sides - ad.interior_sides

# 1178. Too low
# 2186. Too high