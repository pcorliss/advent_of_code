#!/usr/bin/env ruby

require_relative 'reindeer'

input = File.read('./input.txt')

ad = Advent::Reindeer.new(input)
winner = ad.winner(2504)
puts "Winner: #{winner}"
distance = ad.distance(winner, 2504)
puts "Distance: #{distance}"

puts "Points: #{ad.points(2503)}"
