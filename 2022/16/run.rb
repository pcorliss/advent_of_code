#!/usr/bin/env ruby

require_relative 'valveflow'

input = File.read('./input.txt')

ad = Advent::Valveflow.new(input)
ad.debug!
puts ad.most_pressure.gas

# 1186 your answer is too low.
# 1234 your answer is too low.
# 1368 your answer is too low. ---- Ugh, this is after fixing the branching
# 1219 your answer is too low.
# 1376 was correct!

ad = Advent::Valveflow.new(input)
ad.debug!
puts ad.elephant_assisstance.gas

# 1748 your answer is too low.
# 1836 your answer is too low.