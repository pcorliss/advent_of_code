#!/usr/bin/env ruby

require_relative 'cups'

input = File.read('./input.txt')

ad = Advent::Cups.new(input)
100.times { ad.move! }
puts "#{ad.cups_starting_from_1.join('')}"
