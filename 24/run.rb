#!/usr/bin/env ruby

require_relative 'hexagon'

input = File.read('./input.txt')

ad = Advent::Hexagon.new(input)
ad.run!
tiles = ad.grid.values
black_tiles = tiles.count {|t| t % 2 == 1}
white_tiles = tiles.count {|t| t % 2 == 0}
puts "Flips: #{tiles.sum}"
puts "White Tiles: #{white_tiles}"
puts "Black Tiles: #{black_tiles}"

100.times do |i|
  puts "Day #{i + 1}: #{ad.day!}"
end
