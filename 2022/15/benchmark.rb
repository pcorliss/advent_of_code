require 'benchmark'

require_relative 'beacons'

input = File.read('./input.txt')
ad = Advent::Beacons.new(input)

t = Benchmark.measure do
  intervals = ad.sensor_intervals(2_000_000)
end

# puts t.inspect
t_many = t.real * 4_000_000
puts "#{t_many}s, #{t_many / 60}m, #{t_many /60 /60}h"

t = Benchmark.measure do
  intervals = ad.collapsed_intervals(2_000_000)
  puts "I: #{intervals}"
end

# puts t.inspect
t_many = t.real * 4_000_000
puts "#{t_many}s, #{t_many / 60}m, #{t_many /60 /60}h"

t = Benchmark.measure do
  (0..4_000_000).each do |y|
    intervals = ad.collapsed_intervals(y)
    if intervals.count > 1
      puts "Int @ #{y} #{intervals.inspect}"
      break if intervals.count > 1
    end
  end
end

# puts t.inspect
t_many = t.real
puts "#{t_many}s, #{t_many / 60}m, #{t_many /60 /60}h"


# t = Benchmark.measure do
#   ad.null_positions(2000000).count
# end
# puts t.inspect