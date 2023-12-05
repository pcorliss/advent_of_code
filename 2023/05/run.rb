#!/usr/bin/env ruby

require_relative 'almanac'

input = File.read('./input.txt')

ad = Advent::Almanac.new(input)
puts "Lowest Location: #{ad.lowest_location}"

ad = Advent::Almanac.new(input)
# ad.debug!
puts "Lowest Location 2: #{ad.lowest_location_optimized}"

# Lowest Location 2: 70224450
# That's not the right answer; your answer is too high.