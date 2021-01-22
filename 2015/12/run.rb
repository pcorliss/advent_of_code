#!/usr/bin/env ruby

require_relative 'accounting'

input = File.read('./input.txt')

ad = Advent::Accounting.new(input)
puts "Numbers: #{ad.numbers.sum}"
puts "Numbers: #{ad.json_numbers.sum}"
puts "Non-Red Numbers: #{ad.non_red_numbers.sum}"

# 38489 is too low
