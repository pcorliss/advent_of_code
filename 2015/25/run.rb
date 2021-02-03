#!/usr/bin/env ruby

require_relative 'code'

input = File.read('./input.txt')

ad = Advent::Code.new(input)
puts "Grid Pos: #{ad.grid_pos}"
n = ad.grid_n(ad.grid_pos)
puts "Nth Val: #{n}"
code = ad.code_gen(n)
puts "Code: #{code}"
