#!/usr/bin/env ruby

require_relative 'turing'

input = File.read('./input.txt')

ad = Advent::Turing.new(input)
ad.run!
puts "Checksum: #{ad.checksum}"
