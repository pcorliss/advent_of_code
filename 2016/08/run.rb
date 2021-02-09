#!/usr/bin/env ruby

require_relative 'screen'

input = File.read('./input.txt')

ad = Advent::Screen.new(input, 50, 6)
ad.instructions.each do |inst|
  ad.apply!(inst)
end
lights_on = ad.grid.cells.reject { |pos, cell| cell.nil? }
puts "Lights On: #{lights_on.count}"
puts ad.grid.render.gsub('1','X')
