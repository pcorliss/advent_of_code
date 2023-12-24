#!/usr/bin/env ruby

require_relative 'hail'

input = File.read('./input.txt')

ad = Advent::Hail.new(input)
bounds = [[200000000000000,200000000000000],[400000000000000,400000000000000]]
puts "Part 1: #{ad.matching_intersections(bounds)}"