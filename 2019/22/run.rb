#!/usr/bin/env ruby

require_relative 'shuffle'

input = File.read('./input.txt')

ad = Advent::Shuffle.new(input)
ad.run!

puts "Deck 2019: #{ad.deck.index(2019)}"

# 7022 is incorrect
# Had to get the index of 2019 not the val of the card at pos 2019
