#!/usr/bin/env ruby

require_relative 'cleanup'

input = File.read('./input.txt')

ad = Advent::Cleanup.new(input)
puts ad.count_cover
puts ad.count_overlap