#!/usr/bin/env ruby

require_relative 'cups'

input = File.read('./input.txt')

ad = Advent::Cups.new(input, 9, false)
100.times { ad.move! }
puts "#{ad.cups_starting_from_1.join('')}"


require 'benchmark'
b = Benchmark.measure do
  1_000.times { ad.move! }
end
puts b

ad = Advent::Cups.new(input, 1_000_000, false)

b = Benchmark.measure do
  1_000.times { ad.move! }
end
puts b

require 'ruby-prof'

ad = Advent::Cups.new(input, 1_000_000, false)
RubyProf.start
1_000.times { ad.move! }
result = RubyProf.stop

printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
# printer = RubyProf::GraphPrinter.new(result)
# printer.print(STDOUT)

exit

ad = Advent::Cups.new(input, 1_000_000, false)
10_000_000.times { ad.move! }
index_of_one = ad.cups.index(1)
cups = ad.cups.slice((index_of_one + 1)..(index_of_one + 3))
puts "#{cups}"
puts "#{cups.inject(:*)}"
