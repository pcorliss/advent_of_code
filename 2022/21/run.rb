#!/usr/bin/env ruby

require_relative 'monkey'

input = File.read('./input.txt')

ad = Advent::Monkey.new(input)
puts "Root: #{ad.lookup(:root)}"
