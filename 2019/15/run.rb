#!/usr/bin/env ruby

require_relative 'oxygen'

input = File.read('./input.txt')

ad = Advent::Oxygen.new(input)
until ad.grid_filled? do
  ad.move!
  # puts ad.grid.render
  # puts "#{ad.iter} #{ad.paths.map {|p| p[:pos] }}} ------------"
  # puts "#{ad.sensor} #{ad.sensor_found_in} ----------"
end

until ad.inflate! do
  puts ad.grid.render
  puts "#{ad.inflate_iter} #{ad.inflate_paths.map {|p| p[:pos] }}} ------------"
end

# 411 is too high
# 383 is too low
# Off by one error? 410 is right.
