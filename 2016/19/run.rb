#!/usr/bin/env ruby

require_relative 'circle'

input = File.read('./input.txt')

ad = Advent::Circle.new(input)
i = 0
loop do 
  ad.step!
  i += 1
  puts "#{i} - #{ad.current_elf.val}" if i % 100_000 == 0
  break if ad.current_elf.next == ad.current_elf
end

puts "Last elf: #{ad.current_elf.val}"
