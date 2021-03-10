#!/usr/bin/env ruby

require_relative 'dancing'

input = File.read('./input.txt')

ad = Advent::Dancing.new(input)
ad.run!
puts "Line: #{ad.line.join}"

ad = Advent::Dancing.new(input)
require 'benchmark'
b = Benchmark.measure do
  1_000.times { ad.run! }
end
puts "B: #{b}"
puts "Line: #{ad.line.join}"
