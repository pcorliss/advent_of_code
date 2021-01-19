#!/usr/bin/env ruby

require_relative 'adventcoins'

input = File.read('./input.txt')

ad = Advent::AdventCoins.new(input)
puts "Next Coin: #{ad.next_coin}"

ad = Advent::AdventCoins.new(input, 6)
puts "Next Coin: #{ad.next_coin}"
