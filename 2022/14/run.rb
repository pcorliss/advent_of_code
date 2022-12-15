#!/usr/bin/env ruby

require_relative 'falling'

input = File.read('./input.txt')

ad = Advent::Falling.new(input)
puts ad.fill_sand!
