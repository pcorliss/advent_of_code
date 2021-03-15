#!/usr/bin/env ruby

require_relative 'swarm'

input = File.read('./input.txt')

ad = Advent::Swarm.new(input)
min_acc = ad.closest_long_term
min_part = ad.particles[min_acc]
puts "Min Acc: #{min_acc}"
puts "Min Part: #{min_part}"

# too low...
# Min Acc: 119
# Min Part: [[-3329, 585, 1447], [98, -17, -8], [0, 0, -2]]
#

ad = Advent::Swarm.new(input)
ad.debug!
col = ad.collision
puts "Collisions: #{col}"
puts "Remaining: #{ad.particles.count - col.count}"
