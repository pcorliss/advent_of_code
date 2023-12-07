#!/usr/bin/env ruby

require_relative 'camelcards'

input = File.read('./input.txt')

ad = Advent::Camelcards.new(input)
puts "Total Winnings: #{ad.total_winnings}"
puts "Total Winnings 2: #{ad.total_winnings_2}"