#!/usr/bin/env ruby

require_relative 'towers'

input = File.read('./input.txt')

ad = Advent::Towers.new(input)
puts "Bottom: #{ad.bottom}"
