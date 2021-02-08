#!/usr/bin/env ruby

require_relative 'security'

input = File.read('./input.txt')

ad = Advent::Security.new(input)
sum = ad.rooms.select { |room| ad.real?(room) }.sum {|room| ad.room_comp(room)[:sector_id] }

puts "Sum: #{sum}"
