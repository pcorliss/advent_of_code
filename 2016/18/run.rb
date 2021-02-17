#!/usr/bin/env ruby

require_relative 'tiles'

input = File.read('./input.txt')

ad = Advent::Tiles.new(input)

i = 1
prev_safe = ad.safe_tiles

while i <= 40 do
  ad.fill_rows!(i)
  i += 1
  safe = ad.safe_tiles
  puts "#{i} - #{safe} #{prev_safe} #{safe - prev_safe}"
  prev_safe = safe
end


ad.fill_rows!(40)
puts "Render:\n#{ad.grid.render}"
puts "Safe Tiles: #{ad.safe_tiles}"

i = 1000
while i <= 400000 do
  ad.fill_rows!(i)
  i += 1000
  puts "Filled to #{i}" if i % 10_000 == 0
end

puts "Safe Tiles: #{ad.safe_tiles}"
