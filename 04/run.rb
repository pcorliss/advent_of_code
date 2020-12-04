#!/usr/bin/env ruby

require_relative 'passport'

input = File.read('./input.txt')

ad = Advent::Four.new(input)
puts ad
