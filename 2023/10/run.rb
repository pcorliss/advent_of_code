#!/usr/bin/env ruby

require_relative 'pipes'

input = File.read('./input.txt')

ad = Advent::Pipes.new(input)
puts "Part 1 Steps: #{ad.steps}"
ad.debug!
# puts "Part 2 Inside Cells: #{ad.flood_fill_count}"
puts "Part 2 Inside Cells: #{ad.horizontal_ray.count}"

# That's not the right answer; your answer is too low.
# 324 too low
# 5584 too high