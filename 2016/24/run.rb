#!/usr/bin/env ruby

require_relative 'hvac'

input = File.read('./input.txt')

ad = Advent::Hvac.new(input)
ad.debug!
m = ad.map
puts "Map: #{m.keys} #{m['0']}"
