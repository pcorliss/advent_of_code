#!/usr/bin/env ruby

require_relative 'steps'

input = File.read('./input.txt')

ad = Advent::Steps.new(input)
steps = ad.steps(ad.start, 64)
puts "Part 1: #{steps}"

ad = Advent::Steps.new(input)
ad.debug!
puts "Part 2: #{ad.steps(ad.start, 26501365)}"