#!/usr/bin/env ruby

require_relative 'packets'

input = File.read('./input.txt')

ad = Advent::Packets.new(input)
ad.run_until_255

ad = Advent::Packets.new(input)
# ad.run_until_packets_empty
ad.run_and_capture_nat

# 14834 your answer is too high
