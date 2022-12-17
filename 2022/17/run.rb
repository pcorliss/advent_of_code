#!/usr/bin/env ruby

require_relative 'tetris'

input = File.read('./input.txt')

ad = Advent::Tetris.new(input)
2022.times { ad.rock! }
puts ad.tower_height
