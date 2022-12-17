#!/usr/bin/env ruby

require_relative 'valveflow'

input = File.read('./input.txt')

ad = Advent::Valveflow.new(input)
ad.debug!
# puts ad.most_pressure.gas

# 1186 your answer is too low.
# 1234 your answer is too low.