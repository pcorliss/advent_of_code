#!/usr/bin/env ruby

require_relative 'tuning'

input = File.read('./input.txt')

ad = Advent::Tuning.new(input)
puts ad.marker