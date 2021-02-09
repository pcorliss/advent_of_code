#!/usr/bin/env ruby

require_relative 'bots'

input = File.read('./input.txt')

ad = Advent::Bots.new(input)
bot = ad.find_common_bot(61,17)
puts "Common Bot: #{bot}"
