#!/usr/bin/env ruby

require_relative 'docking'

input = File.read('./input.txt')

ad = Advent::Docking.new(input)
puts "Sum: #{ad.sum}"
ad = Advent::Docking.new(input, true)
puts "Sum: #{ad.sum_prime}"
