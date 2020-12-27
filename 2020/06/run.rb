#!/usr/bin/env ruby

require_relative 'customs'

input = File.read('./input.txt')

ad = Advent::Six.new(input)
puts "Sum: #{ad.forms.map(&:answer_count).sum}"
puts "Unan: #{ad.forms.map(&:unanimous_count).sum}"
