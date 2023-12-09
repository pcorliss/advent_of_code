#!/usr/bin/env ruby

require_relative 'sequences'

input = File.read('./input.txt')

ad = Advent::Sequences.new(input)
puts "Part 1 Sum: #{ad.sum_next_number}"
puts "Part 2 Sum: #{ad.sum_prev_number}"