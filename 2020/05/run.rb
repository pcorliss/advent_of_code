#!/usr/bin/env ruby

require_relative 'seat'

input = File.read('./input.txt')

ad = Advent::Five.new(input)
puts "Max Seat ID: #{ad.max_seat_id}"
puts "Missing Seat: #{ad.missing_seat_id}"
