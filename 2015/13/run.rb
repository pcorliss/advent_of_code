#!/usr/bin/env ruby

require_relative 'knights'

input = File.read('./input.txt')

ad = Advent::Knights.new(input)
optimal = ad.optimal
puts "Optimal Config: #{optimal}"
sum = ad.sum_happiness(optimal)
puts "Sum Happiness: #{sum}"


ad = Advent::Knights.new(input)
ad.happy_map['Phil'] = {}
ad.guests.each do |guest|
  ad.happy_map[guest]['Phil'] = 0
  ad.happy_map['Phil'][guest] = 0
end
ad.guests << 'Phil'

optimal = ad.optimal
puts "Optimal Config: #{optimal}"
sum = ad.sum_happiness(optimal)
puts "Sum Happiness: #{sum}"
