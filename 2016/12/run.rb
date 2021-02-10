#!/usr/bin/env ruby

require_relative 'assembly'

input = File.read('./input.txt')

ad = Advent::Assembly.new(input)
ad.run!
puts "Registers: #{ad.registers}"

ad = Advent::Assembly.new(input)
ad.registers[:c] = 1
ad.run!
puts "Registers: #{ad.registers}"
