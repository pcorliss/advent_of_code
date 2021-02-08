#!/usr/bin/env ruby

require_relative 'signal'

input = File.read('./input.txt')

ad = Advent::Signal.new(input)
puts "Error Corrected: #{ad.error_correct}"
puts "Least Common: #{ad.least_common}"
