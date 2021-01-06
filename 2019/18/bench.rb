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

# result = nil
# b = Benchmark.measure do
#   ad = Advent::Maze.new(C_SAMPLE)
#   RubyProf.start
#   ad.steps_until_finished
#   result = RubyProf.stop
# end
#
# puts "B: #{b}"
# printer = RubyProf::FlatPrinter.new(result)
# printer.print(STDOUT)

H_SAMPLE = <<~EOS
#############
#g#f.D#..h#l#
#F###e#E###.#
#dCba@\#@BcIJ#
#############
#nK.L@\#@G...#
#M###N#H###.#
#o#m..#i#jk.#
#############
EOS


result = nil
b = Benchmark.measure do
  ad = Advent::MultiMaze.new(H_SAMPLE)
  ad.map
  ad.bfs
end
puts "B: #{b}"

  ad = Advent::MultiMaze.new(H_SAMPLE)
  ad.map
  RubyProf.start
  ad.bfs
  result = RubyProf.stop

printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
require 'pilfer'

reporter = Pilfer::Logger.new('./pilfer.log')
profiler = Pilfer::Profiler.new(reporter)
ad = Advent::MultiMaze.new(H_SAMPLE)
ad.map
profiler.profile('maze finding') do
  ad.bfs
end
