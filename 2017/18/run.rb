#!/usr/bin/env ruby

require_relative 'duet'

input = File.read('./input.txt')

ad = Advent::Duet.new(input)
ad.debug!
ad.run!
puts "Last Sound: #{ad.last_sound}"
puts "Registers: #{ad.registers}"

counts = Advent::DuetPrime.run!(input, debug: false)
puts "Counts: #{counts}"
