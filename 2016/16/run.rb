#!/usr/bin/env ruby

require_relative 'dragon'

input = File.read('./input.txt')

ad = Advent::Dragon.new(input)
encoded = ad.dragon(ad.inp, 272)
puts "Encoded: #{encoded}"
checksum = ad.checksum(encoded)
puts "Checksum: #{checksum}"

encoded = ad.dragon(ad.inp, 35651584)
puts "Encoded: #{encoded.length}"
checksum = ad.checksum(encoded)
puts "Checksum: #{checksum}"
