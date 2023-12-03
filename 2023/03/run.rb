#!/usr/bin/env ruby

require_relative 'gear'

input = File.read('./input.txt')

ad = Advent::Gear.new(input)
puts "Part 1: #{ad.part_nums.sum}"

# That's not the right answer; your answer is too low.
# Part 1: 330744
# Part 1: 537053