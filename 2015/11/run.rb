#!/usr/bin/env ruby

require_relative 'policy'

input = File.read('./input.txt')

ad = Advent::Policy.new(input)
next_pw = ad.next_valid_password('hxbxwxba')
puts "Next: #{next_pw}"
next_pw = ad.next_valid_password('hxbxxyzz')
puts "Next: #{next_pw}"
