#!/usr/bin/env ruby

require_relative 'bags'

input = File.read('./input.txt')

ad = Advent::Bag.new(input)
puts "Shiny Gold: #{ad.holding_bags('shiny gold').count}"
