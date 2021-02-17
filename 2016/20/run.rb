#!/usr/bin/env ruby

require_relative 'firewall'

input = File.read('./input.txt')

ad = Advent::Firewall.new(input)
l = ad.lowest
puts "Lowest: #{l}"

# Too low 753115
