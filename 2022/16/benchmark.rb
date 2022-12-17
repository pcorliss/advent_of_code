require 'benchmark'

iterations = 10_000_000

arr = iterations.times.to_a
t = Benchmark.measure do
  iterations.times { arr.shift }
end
puts "Shift: #{t.real}s"

arr = iterations.times.to_a
t = Benchmark.measure do
  iterations.times { arr.pop }
end
puts "Pop: #{t.real}s"