#!/usr/bin/env ruby

require_relative 'climbing'

input = File.read('./input.txt')

ad = Advent::Climbing.new(input)
puts ad.shortest_path.count - 1