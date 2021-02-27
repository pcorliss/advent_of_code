#!/usr/bin/env ruby

require_relative 'spiral'

input = File.read('./input.txt')

ad = Advent::Spiral.new(input)
ad.debug!
x, y = ad.get_pos(ad.square)
puts "Pos: #{x},#{y}"
puts "Manhattan: #{x.abs + y.abs}"

val = ad.gen_grid(ad.square)
puts "Val: #{val}"

