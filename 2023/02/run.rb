#!/usr/bin/env ruby

require_relative 'cubes'

input = File.read('./input.txt')

ad = Advent::Cubes.new(input, {red: 12, blue: 14, green: 13 })
puts "Sum of possible games: #{ad.possible_game_sum}"
puts "Sum of minimum cubes power: #{ad.minimum_cubes_power_sum}"