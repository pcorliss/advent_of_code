#!/usr/bin/env ruby

require_relative 'crypt'

input = File.read('./input.txt')

ad = Advent::Crypt.new(input, 25)
# puts "First Invalid: #{ad.first_invalid_num}"
puts "weakness sum: #{ad.sum_first_last_contig(ad.first_invalid_num)}"
