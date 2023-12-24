#!/usr/bin/env ruby

require_relative 'hike'

input = File.read('./input.txt')

ad = Advent::Hike.new(input)
puts "Part 1 Longest Hike: #{ad.longest_hike}"
ad = Advent::Hike.new(input)
ad.debug!
ad.build_graph
puts ad.render_graph_on_grid
puts ad.state_diagram

ad = Advent::Hike.new(input)
ad.debug!
puts "Part 2 Longest Hike: #{ad.longest_hike(ignore_slopes: true)}"