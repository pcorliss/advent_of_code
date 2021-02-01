#!/usr/bin/env ruby

require_relative 'presents'
require 'prime'

input = File.read('./input.txt').chomp.to_i

ad = Advent::Presents.new
# house = ad.find_house(input)
# puts "House: #{house} for #{input}"

p_map = 1000.times.map do |i|
  ad.presents(i)
end

best = 0
bests = {}
prime_adjacent_h = {true => 0, false => 0}

(2000..3000).each do |i|
  p = ad.presents(i)
  prime = i.prime? ? " Prime" : ""
  if p > best
    prime_adjacent = (i - 1).prime? || (i + 1).prime?
    prime_adjacent_h[prime_adjacent] += 1
    puts "#{i}\t#{p} New Best #{(i - 1).prime?}#{(i + 1).prime?}" if prime_adjacent
    bests[i] = p
    best = p
  else
    # puts "#{i}\t#{p}#{prime}"
  end
end

puts "Max: #{p_map.max} #{p_map.index(p_map.max)}"
puts "Mean: #{p_map.sum / p_map.count}"
puts "Bests: #{bests}"
puts "Prime Adjacent: #{prime_adjacent_h}"

ad.debug!
house = ad.find_house_prime(input)
puts "House: #{house} for #{input}"
