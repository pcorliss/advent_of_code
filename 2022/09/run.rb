#!/usr/bin/env ruby

require_relative 'rope'

input = File.read('./input.txt')

ad = Advent::Rope.new(input)
puts ad.visited
ad = Advent::Rope.new(input, 10)
puts ad.visited