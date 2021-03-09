#!/usr/bin/env ruby

require_relative 'generators'

input = File.read('./input.txt')

ad = Advent::Generators.new(input)
matches = ad.sample(40_000_000)
puts "Matches: #{matches}"

ad = Advent::Generators.new(input)
matches = ad.sample(5_000_000, [4, 8])
puts "Matches: #{matches}"
