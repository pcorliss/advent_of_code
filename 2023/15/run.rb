#!/usr/bin/env ruby

require_relative 'lens'

input = File.read('./input.txt')

ad = Advent::Lens.new(input)
puts "Part 1 Command Hash Sum: #{ad.command_hash_sum}"
