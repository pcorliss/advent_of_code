#!/usr/bin/env ruby

require_relative 'distress'

input = File.read('./input.txt')

ad = Advent::Distress.new(input)
puts ad.idx_of_pairs_in_right_order.sum

# Answer is too low 694

puts ad.decoder_key