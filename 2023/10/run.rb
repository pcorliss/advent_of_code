#!/usr/bin/env ruby

require_relative 'pipes'

input = File.read('./input.txt')

ad = Advent::Pipes.new(input)
puts "Part 1 Steps: #{ad.walk}"