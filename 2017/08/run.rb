#!/usr/bin/env ruby

require_relative 'registers'

input = File.read('./input.txt')

ad = Advent::Registers.new(input)
max_val = ad.run!
max = ad.registers.values.max
puts "Registers: #{ad.registers}"
puts "Max Register: #{max}"
puts "Max Val: #{max_val}"
