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
