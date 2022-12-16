#!/usr/bin/env ruby

require_relative 'beacons'

input = File.read('./input.txt')

ad = Advent::Beacons.new(input)
puts ad.null_positions(2000000).count

# ad.debug!
beacon = ad.find_beacon([0,0], [4000000,4000000])
puts beacon
puts ad.tuning_frequency(beacon)