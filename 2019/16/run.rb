#!/usr/bin/env ruby

require_relative 'freq'

input = File.read('./input.txt')

ad = Advent::Freq.new(input)
100.times { ad.phase! }
dig = ad.digits.first(8).map(&:to_s).join("")
puts "Digits: #{dig} #{ad.digits}"
