#!/usr/bin/env ruby

require_relative 'grove'

input = File.read('./input.txt')

ad = Advent::Grove.new(input)
ad.mix
puts "Coords: #{ad.coords}"
puts "Sum: #{ad.coords.sum}"
