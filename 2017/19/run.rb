#!/usr/bin/env ruby

require_relative 'path'

input = File.read('./input.txt')

ad = Advent::Path.new(input)
follow = ad.follow
letters = follow[:letters]
steps = follow[:steps]
puts "Letters: #{letters.join}"
puts "Steps: #{steps}"
