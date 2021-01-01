#!/usr/bin/env ruby

require_relative 'fuel'

input = File.read('./input.txt')

ad = Advent::Fuel.new(input)
ad.debug!
puts "Base Chems: #{ad.base_chems}"
puts "Max Fuel: #{ad.max_fuel}"
