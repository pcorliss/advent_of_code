#!/usr/bin/env ruby

require_relative 'lights'

input = File.read('./input.txt')

ad = Advent::Lights.new(input)
100.times { ad.step! }
on_count = ad.grid.cells.count do |pos, cell|
  cell == '#'
end

puts "On Count: #{on_count}"
