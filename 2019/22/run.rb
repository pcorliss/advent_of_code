#!/usr/bin/env ruby

require_relative 'shuffle'

input = File.read('./input.txt')

ad = Advent::Shuffle.new(input)
ad.run!

puts "Deck 2019: #{ad.deck.index(2019)}"

# 7022 is incorrect
# Had to get the index of 2019 not the val of the card at pos 2019

# ad = Advent::Shuffle.new(input, 119315717514047)
# puts "Allocated!"
# 101741582076661.times do |i|
#   ad.run!
#   puts "#{i}"
# end
# puts "Deck @2020: #{ad.deck[2020]}"
