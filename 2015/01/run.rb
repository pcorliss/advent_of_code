#!/usr/bin/env ruby

require_relative 'parans'

input = File.read('./input.txt')

ad = Advent::Parans.new(input)
puts "Floor: #{ad.floor}"
puts "First Basement: #{ad.first_basement}"
