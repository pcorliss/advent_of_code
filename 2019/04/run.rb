#!/usr/bin/env ruby

require_relative 'password'

input = File.read('./input.txt')

ad = Advent::Password.new(input)
puts "Valid Nums: #{ad.valid_numbers.count}"
puts "Valid Nums: #{ad.valid_numbers_prime.count}"
