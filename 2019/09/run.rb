#!/usr/bin/env ruby

require_relative '../lib/intcode.rb'

input = File.read('./input.txt')

ad = Advent::IntCode.new(input)
ad.program_input = 1
ad.run!
puts "Out: #{ad.full_output}"
ad = Advent::IntCode.new(input)
ad.program_input = 2
ad.run!
puts "Out: #{ad.full_output}"
