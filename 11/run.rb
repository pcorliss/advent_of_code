#!/usr/bin/env ruby

require_relative 'seat'

input = File.read('./input.txt')

ad = Advent::Seat.new(input)
ad.stabilize!
puts "Occupied: #{ad.occupied_seats}"

require 'benchmark'
b = Benchmark.measure do 
  5.times do
    ad = Advent::Seat.new(input)
    ad.stabilize_prime!
  end
end
puts "Time: #{b}"
puts "Occupied: #{ad.occupied_seats}"

b = Benchmark.measure do 
  5.times do
    ad = Advent::Seat.new(input, true)
    ad.stabilize_prime!
  end
end
puts "Time: #{b}"
