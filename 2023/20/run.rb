#!/usr/bin/env ruby

require_relative 'pulses'

input = File.read('./input.txt')

ad = Advent::Pulses.new(input)
puts "Part 1: #{ad.pulse_mult(1000)}"

ad = Advent::Pulses.new(input)
puts "Part 2: #{ad.rx_cycles}"