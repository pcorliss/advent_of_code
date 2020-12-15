#!/usr/bin/env ruby

require_relative 'memory'

input = File.read('./input.txt')

ad = Advent::Memory.new(input)
puts "2020th: #{ad.goto_turn!(2020)}"
