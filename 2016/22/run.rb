#!/usr/bin/env ruby

require_relative 'gridcomp'

input = File.read('./input.txt')

ad = Advent::Gridcomp.new(input)
viable_count = ad.count_viable_pairs
puts "Viable: #{viable_count}"

ad.debug!
puts ad.render

#fewest_steps = ad.fewest_steps
#puts "Fewest: #{fewest_steps}"

goal_dist = ad.distance_to_goal
puts "Goal Dist: #{goal_dist}"
target_dist = ad.distance_to_target
puts "Target Dist: #{target_dist}"

puts "Steps: #{goal_dist - 1 + (target_dist -1) * 5}"

# 222 & 226 are too high
