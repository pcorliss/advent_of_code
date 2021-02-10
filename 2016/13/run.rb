#!/usr/bin/env ruby

require_relative 'maze'

input = File.read('./input.txt')

ad = Advent::Maze.new(input)
ad.debug!
s = ad.steps([31,39])
puts "Steps: #{s}"
