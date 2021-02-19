#!/usr/bin/env ruby

require_relative 'scramble'

input = File.read('./input.txt')

ad = Advent::Scramble.new(input)
ad.debug!
scrambled = ad.scramble('abcdefgh')

puts "Scrambled: #{scrambled}"

# Incorrect: ehdbfacg
