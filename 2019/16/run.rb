#!/usr/bin/env ruby

require_relative 'freq'

input = File.read('./input.txt')

ad = Advent::Freq.new(input)

require 'benchmark'


# b = Benchmark.measure do
#   100.times { ad.phase! }
# end
#
# puts "Time: #{b}"
# dig = ad.digits.first(8).map(&:to_s).join("")
# puts "Digits: #{dig}"

# 5.times do |i|
#   b = Benchmark.measure do
#     input = File.read("./input.txt") * i
#     ad = Advent::Freq.new(input)
#     100.times { ad.phase! }
#   end
#   puts "Time: #{i} #{b}"
# end

ad = Advent::Freq.new(input.chomp * 10_000)
offset = input.chars.first(7).join('').to_i
ad.set_offset(offset)
100.times { |i| ad.phase_ignore_base; puts "Phase #{i} complete" }
puts "Digits: #{ad.digits.first(8).map(&:to_s).join('')}"

# require 'pry'
# binding.pry

# too high - 61123372 - but completes in 7 seconds
# It turns out we needed to chomp off the trailing newline on input
