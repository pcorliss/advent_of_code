#!/usr/bin/env ruby

require_relative 'crab'

input = File.read('./input.txt')

ad = Advent::Crab.new(input)
ad.combat!
puts "Score: #{ad.score}"
