#!/usr/bin/env ruby

require_relative 'compress'

input = File.read('./input.txt')

ad = Advent::Compress.new(input)
new_str = ad.decode(ad.string)
puts "New String Length: #{new_str.length}"

ad.debug!
l = ad.decode_length(ad.string)
puts "New String Length: #{l}"
