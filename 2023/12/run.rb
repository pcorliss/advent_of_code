#!/usr/bin/env ruby

require_relative 'hotsprings'

input = File.read('./input.txt')

ad = Advent::Hotsprings.new(input)
puts "Part 1 All Possible Arrangements: #{ad.possible_arrangements}"
ad.unfold!
# ad.debug!
puts "Part 2 All Possible Arrangements: #{ad.possible_arrangements}"
# Part 2 All Possible Arrangements: 364628399850
# That's not the right answer; your answer is too low.