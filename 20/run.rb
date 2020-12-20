#!/usr/bin/env ruby

require_relative 'jigsaw'

input = File.read('./input.txt')

ad = Advent::Jigsaw.new(input)
ids = ad.corners.map(&:id)
puts "Ids: #{ids}"
puts "Mult: #{ids.inject(:*)}"
