#!/usr/bin/env ruby

require_relative 'spinlock'

input = File.read('./input.txt')

ad = Advent::Spinlock.new(input)
2016.times { ad.step! }
node = ad.step!
puts "Node: #{node.next.val}"

require 'benchmark'

# ad = Advent::Spinlock.new(input)
# b = Benchmark.measure do
#   100_000.times { ad.step! }
# end
# puts "Step Time: #{b}"

ad = Advent::Spinlock.new(input)
b = Benchmark.measure do
  50_000_000.times { ad.fake_step! }
end
puts "Fake Step Time: #{b}"
puts "Next Zero Val: #{ad.val_next}"


