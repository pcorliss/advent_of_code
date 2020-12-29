#!/usr/bin/env ruby

require_relative 'image'

input = File.read('./input.txt')

ad = Advent::Image.new(input, 25, 6)
layer = ad.layers.min_by do |layer|
  layer.cells.values.count { |v| v == 0 }
end

ones = layer.cells.values.count { |v| v == 1}
twos = layer.cells.values.count { |v| v == 2}

puts "Mult: #{ones * twos}"

puts "Rendered: \n#{ad.compose_layers.render.tr('01',' █')}"
