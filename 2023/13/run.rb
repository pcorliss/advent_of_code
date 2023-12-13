#!/usr/bin/env ruby

require_relative 'reflections'

input = File.read('./input.txt')

ad = Advent::Reflections.new(input)
puts "Part 1: #{ad.reflection_sum}"
