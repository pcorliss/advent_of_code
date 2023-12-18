#!/usr/bin/env ruby

require_relative 'lagoon'

input = File.read('./input.txt')

ad = Advent::Lagoon.new(input)
ad.cut_edge
puts "Grid Edge:\n#{ad.grid.render}"
ad.debug!
ad.fill_lagoon
puts "Filled Lagoon:\n#{ad.grid.render}"
puts "Part 1 Lagoon Size: #{ad.lagoon_size}"
