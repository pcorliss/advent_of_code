#!/usr/bin/env ruby

require_relative 'coproc'

input = File.read('./input.txt')

ad = Advent::Coproc.new(input)
#ad.debug!
ad.run!
puts ad.inst_count
puts "Registers: #{ad.registers}"

# ad = Advent::Coproc.new(input)
# ad.registers[:a] = 1
# ad.debug!
# ad.run!
# puts "Register H: #{ad.registers[:h]}"

r = Hash.new(0)
# r[:a] = 1

# r[:b] = 65              # set b 65
# r[:c] = r[:b]           # set c b
#                         # Skipped # jnz a 2
# if !r[:a].zero?          # Skipped # jnz 1 5
#   r[:b] *= 100            # mul b 100
#   r[:b] += 100_000        # sub b -100000
#   r[:c] = r[:b]           # set c b
#   r[:c] += 17_000         # sub c -17000
# end
# loop do; r[:f] = 1               # set f 1
#   r[:d] = 2               # set d 2
#   loop do; r[:e] = 2               # set e 2
#     loop do; r[:g] = r[:d]           # set g d
#       r[:g] *= r[:e]          # mul g e
#       r[:g] -= r[:b]          # sub g b
#       if r[:g].zero?          # jnz g 2
#         r[:f] = 0 ; end        # set f 0
#       r[:e] += 1              # sub e -1
#       r[:g] = r[:e]           # set g e
#       r[:g] -= r[:b]          # sub g b
#       break if r[:g].zero? ; end # jnz g -8
#     r[:d] += 1              # sub d -1
#     r[:g] = r[:d]           # set g d
#     r[:g] -= r[:b]          # sub g b
#     break if r[:g].zero? ; end # jnz g -13
#   if r[:f].zero?          # jnz f 2
#     r[:h] += 1; end         # sub h -1
#   r[:g] = r[:b]           # set g b
#   r[:g] -= r[:c]          # sub g c
#   if r[:g].zero?          # jnz g 2
#     puts "Registers: #{r}"; return; end; # jnz 1 3
#   r[:b] += 17             # sub b -17
# end # jnz 1 -23

# ad = Advent::Coproc.new(input)
# ad.debug!
# ad.registers[:a] = 1
# ad.run!
# puts ad.inst_count
# puts "Registers: #{ad.registers}"

r = Hash.new(0)
r[:a] = 1

# r[:b] = 65              # set b 65
# r[:c] = r[:b]           # set c b
#                         # Skipped # jnz a 2
#                         # Skipped # jnz 1 5
# r[:b] *= 100            # mul b 100
# r[:b] += 100_000        # sub b -100000
# r[:c] = r[:b]           # set c b
# r[:c] += 17_000         # sub c -17000

require 'prime'
r[:b] = 106_500
r[:c] = 123_500
loop do;
  # r[:f] = 1
  # r[:d] = 2
  # If d * e == b f == zero && h + 1
  if !Prime.prime?(r[:b])
    r[:h] += 1
  else
    r[:p] += 1
  end
  # loop do;
  #   r[:e] = 2
  #   loop do; # loop until 2..106_500...
  #     r[:f] = 0 if r[:d] * r[:e] == r[:b] # if d * e == b break
  #     r[:e] += 1
  #     break if r[:e] == r[:b]
  #   end
  #   r[:d] += 1
  #   break if r[:d] == r[:b]
  # end
  # if r[:f].zero?          # jnz f 2
  #   r[:h] += 1
  # end         # sub h -1
  if r[:b] == r[:c]
    puts "Registers: #{r}";
    return
  end
  r[:b] += 17             # sub b -17
end
