#!/usr/bin/env ruby

require_relative 'treehouse'

input = File.read('./input.txt')

ad = Advent::Treehouse.new(input)
puts ad.count_visible
puts ad.max_scenic_score