#!/usr/bin/env ruby

require_relative 'monkeys'

input = File.read('./input.txt')

ad = Advent::Monkeys.new(input)
20.times { ad.process_round! }
puts ad.monkey_business

ad = Advent::Monkeys.new(input)
ad.no_worries = true
# 10_0000.times { ad.process_round! }
10_000.times { ad.process_round! }
puts ad.monkey_business

# Guessed - 5437123351615 but was too high.
# Realized that I was processing 100_000 rounds instead of 10_000