#!/usr/bin/env ruby

require_relative 'arcade'

input = File.read('./input.txt')

ad = Advent::Arcade.new(input)
ad.run!

puts "Block Tiles: #{ad.grid.cells.values.count {|v| v == 2}}"
puts "Render: \n#{ad.grid.render.tr(*Advent::Arcade::TILES)}"


until ad.program.halted? do
  ad.run!
  puts "Render: \n#{ad.grid.render.tr(*Advent::Arcade::TILES)}"
  puts "Score: #{ad.grid.cells[[-1,0]]}"
end
