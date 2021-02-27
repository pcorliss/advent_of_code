#!/usr/bin/env ruby

require_relative 'spiral'

input = File.read('./input.txt')

ad = Advent::Spiral.new(input)
ad.debug!
x, y = ad.get_pos(ad.square)
puts "Pos: #{x},#{y}"
puts "Manhattan: #{x.abs + y.abs}"

val = ad.gen_grid(ad.square)
puts "Val: #{val}"

ad = Advent::Spiral.new(input)
require 'benchmark'
b = Benchmark.measure do
  1_000.times { ad.get_pos(ad.square) }
end
puts "B Optimized: #{b}"

b2 = Benchmark.measure do
  1_000.times { ad.get_pos_old(ad.square) }
end
puts "B Unoptimized: #{b2}"
puts "B: #{b2 / b}"
