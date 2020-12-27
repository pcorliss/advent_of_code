#!/usr/bin/env ruby

require_relative 'machine'

input = File.read('./input.txt')

ad = Advent::Machine.new(input)
puts "Acc: #{ad.val_before_loop}"
puts "Fixed: #{ad.fix_jmp}"
