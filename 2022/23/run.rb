#!/usr/bin/env ruby

require_relative 'unstable'

input = File.read('./input.txt')

ad = Advent::Unstable.new(input)
10.times { ad.step! }
puts ad.empty_ground