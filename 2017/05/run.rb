#!/usr/bin/env ruby

require_relative 'trampoline'

input = File.read('./input.txt')

ad = Advent::Trampoline.new(input)
steps = ad.run!
puts "Steps: #{steps}"
ad = Advent::Trampoline.new(input)
steps = ad.run!(true)
puts "Steps: #{steps}"
