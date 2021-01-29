#!/usr/bin/env ruby

require_relative 'medicine'

input = File.read('./input.txt')

ad = Advent::Medicine.new(input)
replacements = ad.replacements(ad.molecule).count
puts "Replacement Count: #{replacements}"
