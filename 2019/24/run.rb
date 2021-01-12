#!/usr/bin/env ruby

require_relative 'bugs'

input = File.read('./input.txt')

ad = Advent::Bugs.new(input)
i = 0
until ad.repeat? do
  ad.step!
  i += 1
end
puts "Iterations: #{i}"
puts "Rendered:\n#{ad.grid.render}"
puts "BioRating: #{ad.biodiversity_rating}"


ad = Advent::RecursiveBugs.new(input)
200.times { ad.step! }
count = ad.grid.cells.count { |cell, val| val == '#' }
puts "Bug Count: #{count}"
