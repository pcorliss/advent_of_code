#!/usr/bin/env ruby

require_relative 'alarm'

input = File.read('./input.txt')

ad = Advent::Alarm.new(input)
puts "Start Instructions: #{ad.instructions}"
ad.instructions[1] = 12
ad.instructions[2] = 2
puts "Mod   Instructions: #{ad.instructions}"
ad.run!
puts "Post  Instructions: #{ad.instructions}"
