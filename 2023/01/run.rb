#!/usr/bin/env ruby

require_relative 'trebuchet'

input = File.read('./input.txt')

ad = Advent::Trebuchet.new(input)
puts "Sum: #{ad.sum}"
