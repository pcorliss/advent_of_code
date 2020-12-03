#!/usr/bin/env ruby

require_relative 'traj'

ad = Advent::Three.new(File.read('./input.txt'))
ad.go_to_bottom!
puts "Position: #{ad.pos}"
puts "Trees: #{ad.trees}"
