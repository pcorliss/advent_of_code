#!/usr/bin/env ruby

require_relative 'security'

input = File.read('./input.txt')

ad = Advent::Security.new(input)
positions = ad.run_all_instructions([1,1])
puts "Positions: #{positions}"
code = ad.map_code(positions)
puts "Code: #{code.map(&:to_s).join}"
