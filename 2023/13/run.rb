#!/usr/bin/env ruby

require_relative 'reflections'

input = File.read('./input.txt')

ad = Advent::Reflections.new(input)
puts "Part 1: #{ad.reflection_sum}"
ad = Advent::Reflections.new(input)
puts "Part 2: #{ad.reflection_sum(true)}"
# Part 2: 36327
# Part 2: 38025 - Prefering horizontals over verticals
# Fixed issue where I was using difference instead of bitwise-XOR
# That's not the right answer; your answer is too low.