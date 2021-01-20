#!/usr/bin/env ruby

require_relative 'match'

input = File.read('./input.txt')

ad = Advent::Match.new(input)
tot = ad.total_code_minus_str
puts "Total: #{tot}"
# 1379 is too high
