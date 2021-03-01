#!/usr/bin/env ruby

require_relative 'debugger'

input = File.read('./input.txt')

ad = Advent::Debugger.new(input)
# ad.debug!
puts "Blocks: #{ad.blocks}"
steps = ad.run!
puts "Steps: #{steps} #{ad.blocks}"
puts "Previous Step: #{ad.states[ad.blocks.hash]}"
puts "Difference: #{steps - ad.states[ad.blocks.hash]}"
# 15 is not the right answer
