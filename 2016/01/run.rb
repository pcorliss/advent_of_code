#!/usr/bin/env ruby

require_relative 'manhattan'

input = File.read('./input.txt')

ad = Advent::Manhattan.new(input)
ad.walk!
puts "Distance: #{ad.distance}"
# puts "Grid:\n#{ad.grid.render}"
ad = Advent::Manhattan.new(input)
ad.walk!(true)
puts "Distance: #{ad.distance}"
