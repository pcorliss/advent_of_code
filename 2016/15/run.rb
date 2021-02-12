#!/usr/bin/env ruby

require_relative 'discs'

input = File.read('./input.txt')

ad = Advent::Discs.new(input)
ad.debug!
common = ad.find_common
puts "Drop T: #{common}"

ad = Advent::Discs.new(input)
ad.discs << [7,11,0]
ad.debug!
common = ad.find_common
puts "Drop T: #{common}"
