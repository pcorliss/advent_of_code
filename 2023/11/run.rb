#!/usr/bin/env ruby

require_relative 'cosmic'

input = File.read('./input.txt')

ad = Advent::Cosmic.new(input)
puts "Part 1 Shortest Path Sum: #{ad.shortest_path_sum}"
ad = Advent::Cosmic.new(input)

ad.expand_galaxy!(1_000_000)
puts "Part 2 Shortest Path Sum: #{ad.shortest_path_sum}"