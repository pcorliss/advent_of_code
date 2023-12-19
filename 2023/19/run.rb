#!/usr/bin/env ruby

require_relative 'workflow'

input = File.read('./input.txt')

ad = Advent::Workflow.new(input)
puts "Part 1 Accepted Parts Sum: #{ad.accepted_parts_sum}"
