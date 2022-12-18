#!/usr/bin/env ruby

require_relative 'lava'

input = File.read('./input.txt')

ad = Advent::Lava.new(input)
puts ad.exposed_sides
