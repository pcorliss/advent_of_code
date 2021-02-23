#!/usr/bin/env ruby

require_relative 'hvac'

input = File.read('./input.txt')

ad = Advent::Hvac.new(input)
ad.debug!

require 'benchmark'

m = nil
b = Benchmark.measure { m = ad.map }
puts "Map: #{m.keys} #{m['0']}"
puts "Bench: #{b}"

shortest_path = nil
b = Benchmark.measure { shortest_path = ad.fewest_steps }
puts "Shortest Path: #{shortest_path}"
puts "Bench: #{b}"

puts "Steps: #{ad.steps_from_path(shortest_path)}"

b = Benchmark.measure { shortest_path = ad.fewest_steps(true) }
puts "Shortest Path: #{shortest_path}"
puts "Bench: #{b}"

puts "Steps: #{ad.steps_from_path(shortest_path)}"
