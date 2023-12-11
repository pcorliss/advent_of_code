#!/usr/bin/env ruby

require_relative 'pipes'

input = File.read('./input.txt')

ad = Advent::Pipes.new(input)
puts "Part 1 Steps: #{ad.steps}"
# ad.debug!
puts "Part 2 Inside Cells: #{ad.flood_fill_count}"
puts "Part 2 Inside Cells: #{ad.horizontal_ray.count}"

visited, flood_grid = ad.flood_fill

File.open('horizontal_ray.txt', 'w') do |fh|
  g = Grid.new
  inside = ad.horizontal_ray
  inside.each do |cell|
    g[cell] = 'X'
  end
  fh.puts ad.debug_grid(g, visited) 
  fh.puts "Part 2 Inside Cells: #{ad.horizontal_ray.count}"
end

File.open('flood_fill.txt', 'w') do |fh|
  g = Grid.new
  flood_grid.cells.each do |cell, val|
    g[cell] = 'X'
  end
  fh.puts ad.debug_grid(flood_grid, visited)
  fh.puts "Part 2 Inside Cells: #{ad.flood_fill_count}"
end

# That's not the right answer; your answer is too low.
# 324 too low
# 5584 too high