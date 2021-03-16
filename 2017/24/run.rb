#!/usr/bin/env ruby

require_relative 'bridge'

input = File.read('./input.txt')

ad = Advent::Bridge.new(input)
ad.debug!
strongest = ad.strongest_bridge
puts "Strongest: #{strongest}"
strength = ad.strength(strongest)
puts "Strength: #{strength}"

longest = ad.longest_bridge
puts "Longest: #{longest}"
strength = ad.strength(longest)
puts "Strength: #{strength}"

