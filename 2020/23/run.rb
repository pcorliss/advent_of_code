#!/usr/bin/env ruby

require_relative 'cups'

input = File.read('./input.txt')

ad = Advent::Cups.new(input, 9, false)
100.times { ad.move! }
puts "#{ad.cups_starting_from_1.join('')}"

ll = ad.cups_prime
100.times { ll.move! }
arr = ll.to_a(1)
arr.shift
puts "#{arr.join('')}"

require 'benchmark'
b = Benchmark.measure do
  1_000.times { ad.move! }
end
puts b
b = Benchmark.measure do
  1_000.times { ll.move! }
end
puts b

ad = Advent::Cups.new(input, 1_000_000, false)

b = Benchmark.measure do
  1_000.times { ad.move! }
end
puts b
b = Benchmark.measure do
  1_000.times { ll.move! }
end
puts b

# require 'ruby-prof'
#
# ad = Advent::Cups.new(input, 1_000_000, false)
# RubyProf.start
# 1_000.times { ad.move! }
# result = RubyProf.stop
#
# printer = RubyProf::FlatPrinter.new(result)
# printer.print(STDOUT)
# printer = RubyProf::GraphPrinter.new(result)
# printer.print(STDOUT)

# exit

b = Benchmark.measure do
  ad = Advent::Cups.new(input, 1_000_000, false)
  ll = ad.cups_prime
end

puts "Init: #{b}"

b = Benchmark.measure do
  10_000_000.times { ll.move! }
end
puts "10M Moves: #{b}"

cups = nil
b = Benchmark.measure do
  cups = ll.to_a(1).first(3).last(2)
end
puts "Slice: #{b}"

puts "#{cups}"
puts "#{cups.inject(:*)}"
