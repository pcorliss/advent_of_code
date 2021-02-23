#!/usr/bin/env ruby

require_relative 'antenna'

input = File.read('./input.txt')

ad = Advent::Antenna.new(input)

ad.registers[:a] = 200
ad.run_with_check!([0,1])
puts "Output: #{ad.out}"

a = 0
loop do
  ad = Advent::Antenna.new(input)
  ad.registers[:a] = a
  ret = ad.run_with_check!([0,1], 50)
  puts "A: #{a} - Output: #{ad.out}"
  break if ret == 0
  a += 1
end
