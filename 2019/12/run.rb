#!/usr/bin/env ruby

require_relative 'nbody'

input = File.read('./input.txt')

ad = Advent::Nbody.new(input)
1_000.times { ad.step! }
puts "Total Energy: #{ad.moons.map(&:energy).sum}"

ad = Advent::Nbody.new(input)
# i = 0
# until ad.previous_state? do
#   ad.step!
#   i += 1
#   puts "#{i}" if i % 100_000 == 0
# end
# puts "Finished after #{i} steps"

x_cycle = ad.find_cycle(0)
y_cycle = ad.find_cycle(1)
z_cycle = ad.find_cycle(2)
cycles = [x_cycle, y_cycle, z_cycle]
# puts "Cycles: #{cycles}"
# jmp = cycles.max
# i = jmp
# until cycles.all? { |c| i % c == 0 } do
#   i += jmp
#   puts "#{i}" if (i / jmp) % 1_000_000 == 0
# end
# puts "Found common factor #{i}"

cycles = cycles.sort.reverse
max_cycles = cycles[0]
mid_cycles = cycles[1]
min_cycles = cycles[2]

i = max_cycles
jmp = max_cycles

until i % mid_cycles == 0 do
  i += jmp
  puts "#{i}" if (i / jmp) % 1_000_000 == 0
end

puts "Found common cycle for max and mid #{i}"

jmp = i

until i % min_cycles == 0 do
  i += jmp
  puts "#{i}" if (i / jmp) % 1_000_000 == 0
end

puts "Cycles: #{cycles}"
puts "Found common factor #{i}"
