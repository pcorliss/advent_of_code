#!/usr/bin/env ruby

require_relative 'bus'

input = File.read('./input.txt')

ad = Advent::Bus.new(input)
earliest = ad.earliest_bus
puts "Next Bus: #{earliest}"
puts "Mult: #{earliest[0] * earliest[1]}"
