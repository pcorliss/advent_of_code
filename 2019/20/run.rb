#!/usr/bin/env ruby

require_relative 'donut'
require_relative 'recursive_donut'

input = File.read('./input.txt')

ad = Advent::Donut.new(input)
puts "Steps: #{ad.steps}"

ad = Advent::RecursiveDonut.new(input)
puts "Steps: #{ad.steps}"
