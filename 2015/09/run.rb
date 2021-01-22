#!/usr/bin/env ruby

require_relative 'shortest'

input = File.read('./input.txt')

ad = Advent::Shortest.new(input)
puts ad.shortest.inspect
# 719 is too high
puts ad.longest.inspect
