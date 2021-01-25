#!/usr/bin/env ruby

require_relative 'cookie'

input = File.read('./input.txt')

ad = Advent::Cookie.new(input)
opt = ad.optimal
puts "Optimal: #{opt}"
puts "Score: #{ad.score(opt)}"
