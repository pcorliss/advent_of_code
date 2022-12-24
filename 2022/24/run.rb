#!/usr/bin/env ruby

require_relative 'blizzard'

input = File.read('./input.txt')

ad = Advent::Blizzard.new(input)
ad.debug!
puts ad.solve