#!/usr/bin/env ruby

require_relative 'rpg'

input = File.read('./input.txt')

ad = Advent::Rpg.new(input)
win = ad.lowest_cost_win(100)
puts "Win: #{win}"
loss = ad.highest_cost_loss(100)
puts "Loss: #{loss}"
