#!/usr/bin/env ruby

require_relative 'map'

input = File.read('./input.txt')

ad = Advent::Map.new(input)
ad.run
puts ad.password

ad.cube
ad.run_cube
pos, dir = ad.translate_cube
puts "Pos: #{pos}"
puts "Dir: #{dir}"
puts "Pass: #{ad.password(pos, dir)}"

# You guessed 142316. - Too high
# 85249 -- Too High