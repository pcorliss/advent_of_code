#!/usr/bin/env ruby

require_relative 'nav'

input = File.read('./input.txt')

ad = Advent::Nav.new(input)
ad.exec!
puts "Man: #{ad.manhattan}"
