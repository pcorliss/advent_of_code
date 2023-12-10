#!/usr/bin/env ruby

require_relative 'pipes'

input = File.read('./input.txt')

ad = Advent::Pipes.new(input)
puts "Part 1 Steps: #{ad.steps}"
puts "Part 2 Inside Cells: #{ad.flood_fill_count}"

# That's not the right answer; your answer is too low.
# 324