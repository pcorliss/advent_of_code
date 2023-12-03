#!/usr/bin/env ruby

require_relative 'gear'

input = File.read('./input.txt')

ad = Advent::Gear.new(input)
puts "Part 1: #{ad.part_nums.sum}"

# Part 1: 330744
# That's not the right answer; your answer is too low.