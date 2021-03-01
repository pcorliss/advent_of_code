#!/usr/bin/env ruby

require_relative 'debugger'

input = File.read('./input.txt')

ad = Advent::Debugger.new(input)
# ad.debug!
puts "Blocks: #{ad.blocks}"
steps = ad.run!
puts "Steps: #{steps} #{ad.blocks}"

# 15 is not the right answer
