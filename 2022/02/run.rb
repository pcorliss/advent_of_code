#!/usr/bin/env ruby

require_relative 'rps'

input = File.read('./input.txt')

ad = Advent::Rps.new(input)
puts ad.play
