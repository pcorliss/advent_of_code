#!/usr/bin/env ruby

require_relative 'rocks'

input = File.read('./input.txt')

ad = Advent::Rocks.new(input)
ad.tilt!
puts "Part 1 Total Load: #{ad.total_load}"