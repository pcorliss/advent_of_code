#!/usr/bin/env ruby

require_relative 'supply'

input = File.read('./input.txt')

ad = Advent::Supply.new(input)
ad.run!
puts ad.top_of_stacks