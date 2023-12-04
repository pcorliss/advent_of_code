#!/usr/bin/env ruby

require_relative 'scratcher'

input = File.read('./input.txt')

ad = Advent::Scratcher.new(input)
puts "Sum: #{ad.score_sum}"
