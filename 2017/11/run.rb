#!/usr/bin/env ruby

require_relative 'hex'

input = File.read('./input.txt')

ad = Advent::Hex.new(input)
pos = ad.follow_path(ad.steps)
puts "Position: #{pos}"
distance = ad.distance(pos)
puts "Distance: #{distance}"
