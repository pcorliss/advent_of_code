#!/usr/bin/env ruby

require_relative 'medicine'

input = File.read('./input.txt')

ad = Advent::Medicine.new(input)
# require 'pry'
# binding.pry
replacements = ad.replacements(ad.molecule).count
puts "Replacement Count: #{replacements}"

# ad.debug!
# cnt = ad.find_replacement(['e'], ad.molecule)
# puts "Steps to fabricate: #{cnt}"
# Way too slow, made it six steps before failing
#
# ad.debug!
# ad.greedy_backwards(ad.molecule)
#
ad.debug!
# i = ad.greedy_from_the_right(ad.molecule)
# puts "Count: #{i}"
i = ad.greedy_random(ad.molecule)
puts "Count: #{i}"
i = ad.greedy_backwards(ad.molecule)
puts "Count: #{i}"
