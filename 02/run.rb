#!/usr/bin/env ruby

require_relative 'password'

ad = Advent::Two.new(File.read('./input.txt'))
puts "Valid Passwords: #{ad.valid_password_count}"
