#!/usr/bin/env ruby

require_relative 'steps'

input = File.read('./input.txt')

ad = Advent::Steps.new(input)
positions = ad.steps(ad.start, 64)
puts "Part 1: #{positions.length}"
