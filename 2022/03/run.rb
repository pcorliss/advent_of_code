#!/usr/bin/env ruby

require_relative 'rucksacks'

input = File.read('./input.txt')

ad = Advent::Rucksacks.new(input)
puts ad.priority_sum