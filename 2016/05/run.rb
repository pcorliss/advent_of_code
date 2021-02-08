#!/usr/bin/env ruby

require_relative 'md5door'

input = File.read('./input.txt')

ad = Advent::Md5door.new(input)
ad.debug!
pw = ad.gen_pw
puts "PW: #{pw}"

pw = ad.gen_pw_with_pos
puts "PW: #{pw}"
