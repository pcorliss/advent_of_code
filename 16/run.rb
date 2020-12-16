#!/usr/bin/env ruby

require_relative 'ticket'

input = File.read('./input.txt')

ad = Advent::Ticket.new(input)
puts "Sum: #{ad.sum}"
puts "Mappings: #{ad.field_mappings}"
puts "ERROR" if ad.field_mappings.include? nil
puts "Departure: #{ad.departure_info}"
puts "Mult: #{ad.departure_info.inject(:*)}"
