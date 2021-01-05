require 'benchmark'
require_relative 'maze'
require 'ruby-prof'

C_SAMPLE = <<~EOS
#################
#i.G..c...e..H.p#
########.########
#j.A..b...f..D.o#
########@########
#k.E..a...g..B.n#
########.########
#l.F..d...h..C.m#
#################
EOS

result = nil
b = Benchmark.measure do
  ad = Advent::Maze.new(C_SAMPLE)
  RubyProf.start
  ad.steps_until_finished
  result = RubyProf.stop
end

puts "B: #{b}"
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
