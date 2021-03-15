#!/usr/bin/env ruby

require_relative 'fractal'

input = File.read('./input.txt')

ad = Advent::Fractal.new(input)
puts "Rules: #{ad.rules.count}"

g = Grid.new(Advent::Fractal::STARTING_PATTERN)
puts "Begin"
puts g.render
puts ""

5.times do |i|
  g = ad.fractalize!(g)
  puts "Step: #{i + 1} Lights On: #{g.find_all('#').count}"
  puts g.render
  puts ""
end

puts "After 5 iterations Lights On: #{g.find_all('#').count}"
# 132 is too low
# 256 is too high
# 6x6 grids should be divided into 2x2 grids!!!
