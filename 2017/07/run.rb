#!/usr/bin/env ruby

require_relative 'towers'

input = File.read('./input.txt')

ad = Advent::Towers.new(input)
ad.debug!
puts "Bottom: #{ad.bottom}"
node, weight = ad.reweight
puts "Node: #{node} - #{weight}"

# Answer is too hight 25773
# Answer is too high 25767
