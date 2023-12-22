#!/usr/bin/env ruby

require_relative 'slabs'

input = File.read('./input.txt')

ad = Advent::Slabs.new(input)
t = Time.now
ad.drop_bricks!
puts "Bricks Dropped in #{Time.now - t}s"
t = Time.now
puts "Part 1, disintegratable bricks: #{ad.disintegratable_bricks.count}"
puts "Disintegratable Bricks in #{Time.now - t}s"

# 571
# That's not the right answer; your answer is too high.