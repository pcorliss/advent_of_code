#!/usr/bin/env ruby

require_relative 'scramble'

input = File.read('./input.txt')

ad = Advent::Scramble.new(input)
# ad.debug!
scrambled = ad.scramble('abcdefgh')

puts "Scrambled: #{scrambled}"

# Incorrect: ehdbfacg

unscrambled = ad.reverse_scramble_prime('fbgdceah')
puts "Unscrambled: #{unscrambled}"


map = {}
str = "abcdefgh"
str.length.times do |i|
  letter = str[i]
  ad = Advent::Scramble.new("rotate based on position of letter #{letter}")
  s = ad.scramble(str)
  map[i] = s.index(letter)
end
puts "Map: #{map}"

map = {}
str = "abcde"
str.length.times do |i|
  letter = str[i]
  ad = Advent::Scramble.new("rotate based on position of letter #{letter}")
  s = ad.scramble(str)
  map[i] = s.index(letter)
end
puts "Map: #{map}"
