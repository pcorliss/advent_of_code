#!/usr/bin/env ruby

require_relative 'shuffle'

input = File.read('./input.txt')

ad = Advent::Shuffle.new(input)
# ad.debug!
ad.run!
puts "Deck 2019: #{ad.deck.to_a.index(2019)}"

# 7022 is incorrect
# Had to get the index of 2019 not the val of the card at pos 2019

ad = Advent::Shuffle.new(input, 119315717514047)
# ad.debug!
ad.run!
# puts "Allocated!"
require 'benchmark'
b = Benchmark.measure do
  ad.deck.calc_offset_and_increment()
  puts "Deck Offset: #{ad.deck.offset}"
  puts "Deck Increment: #{ad.deck.increment}"
  ad.deck.calc_offset_and_increment(101741582076661)
  puts "Deck Offset: #{ad.deck.offset}"
  puts "Deck Increment: #{ad.deck.increment}"
end
puts "B: #{b}"

puts "2020th Card: #{ad.deck[2020]}"

# Deck Offset: 99057886680701
# Deck Increment: 66385277977328
# 86452915094433 is incorrect
# 20067637117105 is too high
