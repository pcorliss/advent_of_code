#!/usr/bin/env ruby

require_relative 'fuel'

input = File.read('./input.txt')

ad = Advent::Fuel.new(input)
puts "Base Chems: #{ad.base_chems}"
