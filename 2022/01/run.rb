#!/usr/bin/env ruby

require_relative 'calories'

input = File.read('./input.txt')

ad = Advent::Calories.new(input)
puts ad.most_calories
