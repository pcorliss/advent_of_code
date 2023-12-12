#!/usr/bin/env ruby

require_relative 'hotsprings'

input = File.read('./input.txt')

ad = Advent::Hotsprings.new(input)
puts "Part 1 All Possible Arrangements: #{ad.possible_arrangements}"