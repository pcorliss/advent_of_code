#!/usr/bin/env ruby

require_relative 'chcksum'

input = File.read('./input.txt')

ad = Advent::Chcksum.new(input)
puts "Checksum: #{ad.checksum}"
