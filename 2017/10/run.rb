#!/usr/bin/env ruby

require_relative 'knots'

input = File.read('./input.txt')

ad = Advent::Knots.new(input)
# ad.debug!
ad.run!
first_two_mult = ad.ring.first(2).inject(:*)
puts "First Two Mult: #{first_two_mult}"

ad = Advent::Knots.new(input)
# ad.debug!
ad.run_prime!
puts "Hex: #{ad.to_hex}"

