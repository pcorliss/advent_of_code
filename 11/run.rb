#!/usr/bin/env ruby

require_relative 'seat'

input = File.read('./input.txt')

ad = Advent::Seat.new(input)
i = 0
changed = 1
last_changed = 2
while changed > 0
  changed = ad.tick!
  puts "#{i}: Changes: #{changed} :: #{ad.seats.first(30).join("")}"
  puts "\tOccupied: #{ad.occupied_seats}"
  i += 1
  if last_changed == changed
    puts "Unstable?"
    break
  end
  last_changed = changed
end

puts "Occupied: #{ad.occupied_seats}"
