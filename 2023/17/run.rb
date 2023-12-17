#!/usr/bin/env ruby

require_relative 'crucible'

input = File.read('./input.txt')

ad = Advent::Crucible.new(input)
t = Time.now
puts "Part 1: #{ad.path_find}"
puts "Duration: #{Time.now - t}s"
t = Time.now
puts "Part 2: #{ad.path_find(min: 4, max: 10)}"
puts "Duration: #{Time.now - t}s"

# 1421
# That's not the right answer; your answer is too high.