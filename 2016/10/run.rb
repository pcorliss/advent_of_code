#!/usr/bin/env ruby

require_relative 'bots'

input = File.read('./input.txt')

ad = Advent::Bots.new(input)
ad.debug!
bot = ad.find_common_bot(61,17)
puts "Common Bot: #{bot}"

chips = 3.times.map do |i|
  chip = ad.output_value(i)
  puts "Chip for output #{i} = #{chip}"
  chip
end

puts "Mult: #{chips.inject(:*)}"
