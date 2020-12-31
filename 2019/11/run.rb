#!/usr/bin/env ruby

require_relative 'police'

input = File.read('./input.txt')

ad = Advent::Police.new(input)
# ad.debug!
#ad.program.debug!
ad.run!
# puts "Cells: #{ad.grid.cells}"
puts "Count: #{ad.grid.cells.count}"
# ~9K was too many
puts "Render:\n#{ad.grid.render.tr('01',' █')}"

ad = Advent::Police.new(input)
ad.init_white_panel!
ad.run!
puts "Count: #{ad.grid.cells.count}"
puts "Render:\n#{ad.grid.render.tr('01',' █')}"
