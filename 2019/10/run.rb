#!/usr/bin/env ruby

require_relative 'monitoring'

input = File.read('./input.txt')

ad = Advent::Monitoring.new(input)
best = ad.best_location
puts "Best Location: #{best}"
puts "Visible From: #{ad.visible_from(best)}"
puts "200th Asteroid: #{ad.asteroid_vaporized(200)}"
puts "Mult: #{ad.asteroid_vaporized(200).first * 100 + ad.asteroid_vaporized(200).last}"
