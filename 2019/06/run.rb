#!/usr/bin/env ruby

require_relative 'orbit'

input = File.read('./input.txt')

ad = Advent::Orbit.new(input)
sum = ad.reverse_orbits.keys.sum do |orb|
  ad.count_orbits(orb)
end
puts "Sum: #{sum}"

puts "Transfers to Santa: #{ad.transfers_between_you_and_santa}"
