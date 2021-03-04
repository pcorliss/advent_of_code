#!/usr/bin/env ruby

require_relative 'garbage'

input = File.read('./input.txt')

ad = Advent::Garbage.new(input)
score = ad.score(ad.str)
puts "Score: #{score}"
