#!/usr/bin/env ruby

require_relative 'lights'

input = File.read('./input.txt')

ad = Advent::Lights.new(input)
ad.debug!
ad.apply!
count = ad.grid.cells.count {|k,v| v == 1}
puts "Lights On: #{count}"

ad = Advent::Lights.new(input)
ad.debug!
ad.bright_apply!
brightness = ad.grid.cells.values.sum
puts "Total Brightness: #{brightness}"
