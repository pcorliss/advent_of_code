#!/usr/bin/env ruby

require_relative 'defrag'

input = File.read('./input.txt')

ad = Advent::Defrag.new(input)

# require 'benchmark'
# t = 100000
# s = "d4f76bdcbf838f8416ccfa8bc6d1f9e6".to_i(16)
#
# b = Benchmark.measure do
#   t.times do
#     ("%0128b" % s).chars.map(&:to_i)
#   end
# end
# puts "B: #{b}"
#
# b = Benchmark.measure do
#   t.times do
#     128.times.inject([]) do |acc, i|
#       j = 127 - i
#       acc << ((s >> j) & 1)
#       acc
#     end
#   end
# end
# puts "B: #{b}"

ad.fill_grid!
puts "Render:\n" + ad.grid.render
used = ad.used_squares
puts "Used: #{used}"
