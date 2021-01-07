#!/usr/bin/env ruby

require_relative 'tractor'

input = File.read('./input.txt')

ad = Advent::Tractor.new(input)
res = ad.find_box(100)
ad.grid[res] = 'X'
puts ad.grid.render
puts res
