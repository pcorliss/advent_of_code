#!/usr/bin/env ruby

require_relative 'onetime'

input = File.read('./input.txt')

ad = Advent::Onetime.new(input)
while ad.keys.count < 64 do
  ad.find_keys(1000)
  puts "Keys: #{ad.keys.count}"
end
puts "64th Key: #{ad.keys.sort[63]}"
