#!/usr/bin/env ruby

require_relative 'nbody'

input = File.read('./input.txt')

ad = Advent::Nbody.new(input)
1_000.times { ad.step! }
puts "Total Energy: #{ad.moons.map(&:energy).sum}"

ad = Advent::Nbody.new(input)
i = 0
until ad.previous_state? do
  ad.step!
  i += 1
  puts "#{i}" if i % 100_000 == 0
end
puts "Finished after #{i} steps"
