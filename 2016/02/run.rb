#!/usr/bin/env ruby

require_relative 'security'

input = File.read('./input.txt')

ad = Advent::Security.new(input)
positions = ad.run_all_instructions([1,1])
puts "Positions: #{positions}"
code = ad.map_code(positions)
puts "Code: #{code.map(&:to_s).join}"

ad = Advent::Security.new(input)
keypad = [
  nil, nil, 1, nil, nil,
  nil, 2, 3, 4, nil,
  5, 6, 7, 8, 9,
  nil, 'A', 'B', 'C', nil,
  nil, nil, 'D', nil, nil,
]
ad.keypad = Grid.new(keypad, 5)

positions = ad.run_all_instructions([0,2])
puts "Positions: #{positions}"
code = ad.map_code(positions)
puts "Code: #{code.map(&:to_s).join}"
