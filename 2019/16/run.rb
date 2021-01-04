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

5.times do |i|
  b = Benchmark.measure do
    input = File.read("./input.txt") * i
    ad = Advent::Freq.new(input)
    100.times { ad.phase! }
  end
  puts "Time: #{i} #{b}"
end
