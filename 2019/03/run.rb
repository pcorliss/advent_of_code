#!/usr/bin/env ruby

require_relative 'wires'

input = File.read('./input.txt')

ad = Advent::Wires.new(input)
puts "Dist: #{ad.distance_intersection}"
puts "Shortest Intersection: #{ad.shortest_intersection}"
