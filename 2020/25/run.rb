#!/usr/bin/env ruby

require_relative 'combo'

input = File.read('./input.txt')

ad = Advent::Combo.new(input)
puts "Key: #{ad.encryption_key}"
