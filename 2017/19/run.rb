#!/usr/bin/env ruby

require_relative 'path'

input = File.read('./input.txt')

ad = Advent::Path.new(input)
letters = ad.follow
puts "Letters: #{letters.join}"
