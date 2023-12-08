#!/usr/bin/env ruby

require_relative 'wasteland'

input = File.read('./input.txt')

ad = Advent::Wasteland.new(input)
puts "Part 1 Steps: #{ad.steps}"
