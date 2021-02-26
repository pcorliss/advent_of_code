#!/usr/bin/env ruby

require_relative 'captch'

input = File.read('./input.txt')

ad = Advent::Captch.new(input)
digits = ad.matches_next_digits(input.chomp)
puts "Matching Digits: #{digits}"
puts "Sum: #{digits.sum}"

# 1332 is too low

digits = ad.matches_opposite_digits(input.chomp)
puts "Matching Digits: #{digits}"
puts "Sum: #{digits.sum}"
