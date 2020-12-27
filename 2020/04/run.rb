#!/usr/bin/env ruby

require_relative 'passport'

input = File.read('./input.txt')

ad = Advent::Four.new(input)
puts "Passport Count: #{ad.passports.count}"
puts "Valid Passports: #{ad.passports.count {|p| p.valid? }}"
