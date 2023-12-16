#!/usr/bin/env ruby

require_relative 'beam'

input = File.read('./input.txt')

ad = Advent::Beam.new(input)
puts "Part 1 Energized: #{ad.energize}"
puts "Rendered:\n#{ad.render_grid}"

# 195
# your answer is too low.