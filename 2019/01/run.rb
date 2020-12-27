#!/usr/bin/env ruby

require_relative 'rocket'

input = File.read('./input.txt')

ad = Advent::Rocket.new(input)
puts "Fuel: #{ad.total_fuel}"
puts "Recursive Fuel: #{ad.total_recursive_fuel}"
