#!/usr/bin/env ruby

require_relative 'wrapping'

input = File.read('./input.txt')

ad = Advent::Wrapping.new(input)
puts "Total Paper: #{ad.total_paper}"
