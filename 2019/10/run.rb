#!/usr/bin/env ruby

require_relative 'monitoring'

input = File.read('./input.txt')

ad = Advent::Monitoring.new(input)
best = ad.best_location
puts "Best Location: #{best}"
puts "Visible From: #{ad.visible_from(best)}"
