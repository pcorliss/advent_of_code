#!/usr/bin/env ruby

require_relative 'firewall'

input = File.read('./input.txt')

ad = Advent::Firewall.new(input)
ad.debug!
l = ad.lowest
puts "Lowest: #{l}"
h = ad.highest
puts "Highest: #{h}"

# Too low 753115

allowed = ad.allowed_count(2**32 - 1)
puts "Allowed: #{allowed}"
