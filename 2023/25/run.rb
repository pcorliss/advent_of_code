#!/usr/bin/env ruby

require_relative 'snowverload'

input = File.read('./input.txt')

ad = Advent::Snowverload.new(input)
# puts ad.state_diagram
ad.debug!

m = ad.maximize_groups(cuts: 3)
puts "Part 1 maximized_groups: #{m} #{m.inject(:*)}"