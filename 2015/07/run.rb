#!/usr/bin/env ruby

require_relative 'circuit'

input = File.read('./input.txt')

require 'pry'
ad = Advent::Circuit.new(input)
ad.debug!
puts "Circuit A: #{ad.resolve('a')}"
# puts "Cache: #{ad.cache}"
# puts "Inst: #{ad.instructions}"
ad.instructions['b'] = ad.resolve('a')
ad.cache = {}
puts "Circ B Overrriden: #{ad.resolve('a')}"
