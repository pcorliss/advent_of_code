#!/usr/bin/env ruby

require_relative 'signals'

input = File.read('./input.txt')

ad = Advent::Signals.new(input)
interesting = ad.interesting_signals
puts interesting.inspect
puts interesting.sum

ad = Advent::Signals.new(input)
puts ad.render
puts ad.grid.highlight
puts ad.grid.ocr