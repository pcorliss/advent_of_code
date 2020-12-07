#!/usr/bin/env ruby

require_relative 'bags'

input = File.read('./input.txt')

ad = Advent::Bag.new(input)
puts "Shiny Gold Contained Within: #{ad.holding_bags('shiny gold').count}"
puts "Shiny Gold Bags Within: #{ad.required_bags('shiny gold')}"
