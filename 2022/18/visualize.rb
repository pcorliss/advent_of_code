require_relative 'lava'

input = File.read('./input.txt')

ad = Advent::Lava.new(input)
ad.render