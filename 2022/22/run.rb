#!/usr/bin/env ruby

require_relative 'map'

input = File.read('./input.txt')

ad = Advent::Map.new(input)
ad.run
puts ad.password

ad.cube