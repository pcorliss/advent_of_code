#!/usr/bin/env ruby

require_relative 'lookandsay'

input = File.read('./input.txt')

ad = Advent::LookAndSay.new(input)
sequence = nil
require 'benchmark'
b = Benchmark.measure do
sequence = 40.times.map { ad.step }.last
end
puts "B: #{b}"
puts "Sequence Length: #{sequence.length}"

ad = Advent::LookAndSay.new(input)
require 'benchmark'
b = Benchmark.measure do
sequence = 50.times.map { ad.step }.last
end
puts "B: #{b}"
puts "Sequence Length: #{sequence.length}"
