#!/usr/bin/env ruby

require_relative 'safecracking'

input = File.read('./mod.txt')

ad = Advent::Safecracking.new(input)
ad.registers[:a] = 7
#ad.debug!
ad.run!
puts "Registers: #{ad.registers}"

ad = Advent::Safecracking.new(input)
ad.registers[:a] = 12
# ad.debug!
ad.run!
puts "Registers: #{ad.registers}"
