#!/usr/bin/env ruby

require_relative 'jigsaw'

input = File.read('./input.txt')

ad = Advent::Jigsaw.new(input)
ids = ad.corners.map(&:id)
puts "Ids: #{ids}"
puts "Mult: #{ids.inject(:*)}"
puts "Grid: #{ad.orient!.map(&:id)}"
puts "Monsters: #{ad.count_monsters}"
# 31 monsters (not correct, they want the number of '#' which aren't monsters"
puts "Waves: #{ad.waves}"
