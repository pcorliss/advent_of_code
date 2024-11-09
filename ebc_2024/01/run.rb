#!/usr/bin/env ruby

require_relative 'potions'

input = File.read('./input_p1.txt')

ad = Advent::Potions.new(input)
puts "Part 1: #{ad.potions}"

input2 = File.read('./input_p2.txt')
ad2 = Advent::Potions2.new(input2)
puts "Part 2: #{ad2.potions}"

input3 = File.read('./input_p3.txt')
ad3 = Advent::Potions2.new(input3, 3)
ad3.debug!
puts "Part 3: #{ad3.potions}"
# 22353 is not correct