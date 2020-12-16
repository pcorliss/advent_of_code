#!/usr/bin/env ruby

require_relative 'ticket'

input = File.read('./input.txt')

ad = Advent::Ticket.new(input)
puts "Sum: #{ad.sum}"
