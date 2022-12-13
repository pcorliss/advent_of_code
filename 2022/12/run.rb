#!/usr/bin/env ruby

require_relative 'climbing'

input = File.read('./input.txt')

ad = Advent::Climbing.new(input)
puts ad.shortest_path.count - 1

best_start = ad.find_best_starting_position
puts "Best Start: #{best_start}"
puts ad.shortest_path([best_start]).count - 1