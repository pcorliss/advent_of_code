#!/usr/bin/env ruby

require_relative 'liters'

input = File.read('./input.txt')

ad = Advent::Liters.new(input)
combos = ad.combos(150)
puts "Combos: #{combos}"
puts "Combos Count: #{combos.count}"

groups = combos.group_by {|comb| comb.count}
smallest = groups.keys.sort.min
different_smallest = groups[smallest]
puts "Smallest: #{smallest}"
puts "Different: #{different_smallest}"
puts "Count: #{different_smallest.count}"
