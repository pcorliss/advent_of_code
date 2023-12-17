#!/usr/bin/env ruby

require_relative 'crucible'

input = File.read('./input.txt')

ad = Advent::Crucible.new(input)
puts "Part 1: #{ad.path_find}"