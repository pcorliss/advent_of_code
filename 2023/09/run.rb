#!/usr/bin/env ruby

require_relative 'sequences'

input = File.read('./input.txt')

ad = Advent::Sequences.new(input)
puts "Part 1 Sum: #{ad.sum_next_number}"