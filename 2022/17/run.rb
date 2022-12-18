#!/usr/bin/env ruby

require_relative 'tetris'

input = File.read('./input.txt')

ad = Advent::Tetris.new(input)
2022.times { ad.rock! }
puts ad.tower_height

# ad = Advent::Tetris.new(input)
# require 'benchmark'

# t = Benchmark.measure do
#   1000.times { ad.rock! }
# end

# expected_seconds = t.real * (1000000000000 / 1000)
# puts "Expected Time: #{expected_seconds}s #{expected_seconds/60}m #{expected_seconds/60/60}h #{expected_seconds/60/60/24}d"

ad = Advent::Tetris.new(input)
ad.debug!
puts ad.cycle_tower_height(2022)
puts ad.cycle_tower_height(1000000000000)