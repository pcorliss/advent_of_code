#!/usr/bin/env ruby

require_relative 'cosmic'

input = File.read('./input.txt')

ad = Advent::Cosmic.new(input)
puts "Part 1 Shortest Path Sum: #{ad.shortest_path_sum}"
