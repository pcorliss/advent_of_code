#!/usr/bin/env ruby

require_relative 'oxygen'

input = File.read('./input.txt')

ad = Advent::Oxygen.new(input)
until ad.grid_filled? do
  ad.move!
  puts ad.grid.render
  puts "#{ad.iter} #{ad.paths.map {|p| p[:pos] }}} ------------"
  puts "#{ad.sensor} #{ad.sensor_found_in} ----------"
end
