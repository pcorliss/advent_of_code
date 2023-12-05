#!/usr/bin/env ruby

require_relative 'almanac'

input = File.read('./input.txt')

ad = Advent::Almanac.new(input)
puts "Lowest Location: #{ad.lowest_location}"
