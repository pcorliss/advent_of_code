#!/usr/bin/env ruby

require_relative 'virus'

input = File.read('./input.txt')

ad = Advent::Virus.new(input)
infections = ad.run!(10_000)
puts "Infections: #{infections}"

ad = Advent::Virus.new(input)
infections = ad.run!(10_000_000, weakened: true)
puts "Infections: #{infections}"
