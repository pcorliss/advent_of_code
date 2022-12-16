#!/usr/bin/env ruby

require_relative 'beacons'

input = File.read('./input.txt')

ad = Advent::Beacons.new(input)
puts ad.null_positions(2000000)