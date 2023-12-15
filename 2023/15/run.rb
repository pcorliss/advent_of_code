#!/usr/bin/env ruby

require_relative 'lens'

input = File.read('./input.txt')

ad = Advent::Lens.new(input)
puts "Part 1 Command Hash Sum: #{ad.command_hash_sum}"

ad.run_all_commands
puts "Part 2 Focusing Power: #{ad.focusing_power}"
