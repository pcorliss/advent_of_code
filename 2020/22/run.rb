#!/usr/bin/env ruby

require_relative 'crab'

input = File.read('./input.txt')

ad = Advent::Crab.new(input)
ad.combat!
puts "Score: #{ad.score}"

ad = Advent::Crab.new(input)
ad.recursive_combat!
puts "Recursive Score: #{ad.score}"

# Recursive Score: 32052
# That's not the right answer; your answer is too low.
# Recursive Score: 7012
# That's not the right answer; your answer is too low.
