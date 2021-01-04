#!/usr/bin/env ruby

require_relative 'flare'

input = File.read('./input.txt')

ad = Advent::Flare.new(input)
ad.fill_grid!
ad.program.full_output.map(&:chr).each { |chr| print chr }
puts "Intersections: #{ad.intersections}"
puts "Sum: #{ad.intersections.sum {|cell| cell[0] * cell[1] }}"
