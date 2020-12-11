#!/usr/bin/env ruby

require_relative 'seat'

input = File.read('./input.txt')

ad = Advent::Seat.new(input)
ad.stabilize!
puts "Occupied: #{ad.occupied_seats}"
