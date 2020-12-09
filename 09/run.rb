#!/usr/bin/env ruby

require_relative 'crypt'

input = File.read('./input.txt')

ad = Advent::Crypt.new(input, 25)
puts "First Invalid: #{ad.first_invalid_num}"
