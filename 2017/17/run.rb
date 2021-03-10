#!/usr/bin/env ruby

require_relative 'spinlock'

input = File.read('./input.txt')

ad = Advent::Spinlock.new(input)
2016.times { ad.step! }
node = ad.step!
puts "Node: #{node.next.val}"

# ad = Advent::Spinlock.new(input)
# require 'benchmark'
# b = Benchmark.measure do
#   1_000_000.times { ad.step! }
# end
# puts "B: #{b}"
