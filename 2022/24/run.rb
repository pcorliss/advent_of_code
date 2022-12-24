#!/usr/bin/env ruby

require_relative 'blizzard'

input = File.read('./input.txt')

ad = Advent::Blizzard.new(input)
ad.debug!
first_leg = ad.solve
puts "First Leg: #{first_leg}"
second_leg = ad.solve(first_leg, ad.goal, ad.exp)
puts "Second Leg: #{second_leg}"
third_leg = ad.solve(second_leg, ad.exp, ad.goal)
puts "Third Leg: #{third_leg}"

# 1757 - That's not the right answer; your answer is too high
# Pretty sure I shouldn't have summed them up

# 994 - That's not the right answer; your answer is too high.