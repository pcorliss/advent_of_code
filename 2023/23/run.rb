#!/usr/bin/env ruby

require_relative 'hike'

input = File.read('./input.txt')

ad = Advent::Hike.new(input)
puts "Part 1 Longest Hike: #{ad.longest_hike}"