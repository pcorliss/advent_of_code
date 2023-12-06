#!/usr/bin/env ruby

require_relative 'wait'

input = File.read('./input.txt')

ad = Advent::Wait.new(input)
puts "Product of number of ways to win: #{ad.number_of_ways_product}"