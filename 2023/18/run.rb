#!/usr/bin/env ruby

require_relative 'lagoon'

input = File.read('./input.txt')

ad = Advent::Lagoon.new(input)
puts "Part 1 Lagoon Size: #{ad.lagoon_size}"

ad = Advent::Lagoon.new(input)
ad.swap_commands
puts "Part 2 Lagoon Size: #{ad.lagoon_size}"