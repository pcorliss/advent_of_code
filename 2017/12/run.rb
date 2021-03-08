#!/usr/bin/env ruby

require_relative 'pipes'

input = File.read('./input.txt')

ad = Advent::Pipes.new(input)
connected = ad.connected(0)
# puts "Connected: #{connected}"
puts "Connected: #{connected.count}"
groups = ad.groups
# puts "Groups: #{groups}"
puts "Groups: #{groups.count}"
