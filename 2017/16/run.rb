#!/usr/bin/env ruby

require_relative 'dancing'

input = File.read('./input.txt')

ad = Advent::Dancing.new(input)
ad.run!
puts "Line: #{ad.line.join}"

ad = Advent::Dancing.new(input)
cycle = ad.find_cycle!
puts "Cycle: #{cycle}"
line = ad.line_after(1_000_000_000)
puts "Line: #{line}"
# require 'benchmark'
# s = {}
# b = Benchmark.measure do
#   1_000.times do |i|
#     if s.has_key? ad.line.join
#       #puts "Dupe Found at #{i}"
#     else
#       s[ad.line.join] = i
#     end
#     ad.run!
#   end
# end
# puts "B: #{b}"
# puts "Line: #{ad.line.join}"
# require 'pry'
# binding.pry
