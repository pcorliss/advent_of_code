#!/usr/bin/env ruby

require_relative 'gridcomp'

input = File.read('./input.txt')

ad = Advent::Gridcomp.new(input)
viable_count = ad.count_viable_pairs
puts "Viable: #{viable_count}"

ad.debug!
fewest_steps = ad.fewest_steps
puts "Fewest: #{fewest_steps}"
