#!/usr/bin/env ruby

require_relative 'triangles'

input = File.read('./input.txt')

ad = Advent::Triangles.new(input)
valid_tri = ad.triangles.count do |tri|
  ad.valid?(tri)
end
puts "Valid Triangles: #{valid_tri}"

ad = Advent::Triangles.new(input, true)
valid_tri = ad.triangles.count do |tri|
  ad.valid?(tri)
end
puts "Valid Triangles: #{valid_tri}"
