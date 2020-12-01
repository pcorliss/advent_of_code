#!/usr/bin/env ruby

require_relative '2020'

ad = Advent::One.new(File.read('./input.txt'))
puts "Sum: #{ad.sum}"
puts "Mult: #{ad.mult}"
puts "Triple: #{ad.triple_sum}"
puts "Triple Mult: #{ad.triple_mult}"
