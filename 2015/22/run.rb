#!/usr/bin/env ruby

require_relative 'rpg'

input = File.read('./input.txt')

ad = Advent::Rpg.new(input)
win = ad.lowest_cost_win(100)
puts "Win: #{win}"
loss = ad.highest_cost_loss(100)
puts "Loss: #{loss}"

ad = Advent::Rpg.new(input)
b = ad.boss
p = {
  hit: 50,
  damage: 0,
  armor: 0,
  mana: 500,
}

ad.debug!
best = ad.best_winning_combo(p, b)
puts "Winning Combo: #{best}"
puts "Winning Combo Mana: #{ad.best_mana}"
# 1295 is too high

ad = Advent::Rpg.new(input)
ad.debug!
b = ad.boss
p = {
  hit: 50,
  damage: 0,
  armor: 0,
  mana: 500,
  effects: [{duration: 1_000_000, burn: 1, mana: 0}]
}
best = ad.best_winning_combo(p, b)
puts "Winning Combo: #{best}"
puts "Winning Combo Mana: #{ad.best_mana}"

# 900 is too low
