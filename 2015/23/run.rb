#!/usr/bin/env ruby

require_relative 'machine'

input = File.read('./input.txt')

ad = Advent::Machine.new(input)
ret = ad.run!
puts "Registers: #{ret}"
