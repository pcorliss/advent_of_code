#!/usr/bin/env ruby

require_relative 'volt'

input = File.read('./input.txt')

ad = Advent::Volt.new(input)
diffs = ad.count_diffs
puts "Diffs: #{diffs.inspect}"
puts "Mult: #{diffs[1] * diffs[3]}"
