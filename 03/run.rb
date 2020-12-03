#!/usr/bin/env ruby

require_relative 'traj'

input = File.read('./input.txt')

ad = Advent::Three.new(input)
ad.go_to_bottom!
puts "Position: #{ad.pos}"
puts "Trees: #{ad.trees}"

mult = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2],
].inject(1) do |acc, slope|
  ad = Advent::Three.new(input, *slope)
  ad.go_to_bottom!
  puts "Trees #{ad.trees} for slope #{slope}"
  acc *= ad.trees
end

puts "Mult: #{mult}"
