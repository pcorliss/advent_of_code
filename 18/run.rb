#!/usr/bin/env ruby

require_relative 'homework'

input = File.read('./input.txt')

ad = Advent::Homework.new(input)
puts "Sum: #{ad.sum}"
