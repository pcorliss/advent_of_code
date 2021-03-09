#!/usr/bin/env ruby

require_relative 'generators'

input = File.read('./input.txt')

ad = Advent::Generators.new(input)
matches = ad.sample(40_000_000)
puts "Matches: #{matches}"
