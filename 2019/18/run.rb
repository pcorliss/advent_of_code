#!/usr/bin/env ruby

require_relative 'maze'
require 'benchmark'

# input = File.read('./input.txt')
# ad = Advent::Maze.new(input)
# ad.debug!
# puts "Steps: #{ad.steps_until_finished}"
#
# exit

input = File.read('./part_two_input.txt')
ad = Advent::MultiMaze.new(input)
ad.debug!
map = nil
b = Benchmark.measure do
  # ~5s to compute full map
  map = ad.map
end

# puts "Map:"
# pp map
puts "Time: #{b}"

best = nil
b = Benchmark.measure do
  best = ad.bfs
  # require 'pilfer'
  # reporter = Pilfer::Logger.new('./pilfer.log')
  # profiler = Pilfer::Profiler.new(reporter)
  # # ad.map
  # profiler.profile('maze finding') do
  #   ad.bfs
  # end
end

puts "Time: #{b}"
puts "Best: #{best}"
puts "Steps: #{best.map {|s| s[2] }.sum}"
