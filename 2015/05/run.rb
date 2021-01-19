#!/usr/bin/env ruby

require_relative 'naughty'

input = File.read('./input.txt')

ad = Advent::Naughty.new(input)
puts "Nice Count: #{ad.nice_count}"
puts "Super Nice Count: #{ad.super_nice_count}"
