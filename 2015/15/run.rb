#!/usr/bin/env ruby

require_relative 'cookie'

input = File.read('./input.txt')

ad = Advent::Cookie.new(input)
opt = ad.optimal
puts "Optimal: #{opt}"
puts "Score: #{ad.score(opt)}"

opt = ad.optimal_with_calories(554)
puts "Optimal: #{opt}"
puts "Score: #{ad.score(opt)}"

opt = ad.optimal_with_calories(500)
puts "Optimal: #{opt}"
puts "Score: #{ad.score(opt)}"

# 14417728 is too low
