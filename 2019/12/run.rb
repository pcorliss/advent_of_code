#!/usr/bin/env ruby

require_relative 'nbody'

input = File.read('./input.txt')

ad = Advent::Nbody.new(input)
1_000.times { ad.step! }
puts "Total Energy: #{ad.moons.map(&:energy).sum}"
