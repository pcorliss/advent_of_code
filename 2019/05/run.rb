#!/usr/bin/env ruby

require_relative 'asteroids'

input = File.read('./input.txt')

ad = Advent::IntCode.new(input)
ad.program_input = 1
ad.run!
puts "Output: #{ad.output}"

ad = Advent::IntCode.new(input)
ad.program_input = 5
ad.run!
puts "Output: #{ad.output}"
