#!/usr/bin/env ruby

require_relative 'flare'

input = File.read('./input.txt')

ad = Advent::Flare.new(input)
ad.fill_grid!
ad.program.full_output.map(&:chr).each { |chr| print chr }
puts "Intersections: #{ad.intersections}"
puts "Sum: #{ad.intersections.sum {|cell| cell[0] * cell[1] }}"
puts "Path: #{ad.calculate_path}"
10.times do |i|
  next if i < 2
  puts "Repeated Sections: #{ad.repeated_sections.select {|path, sec| path.count == i && !path.first.is_a?(Integer) }.sort_by(&:last)}"
end

# A = R, 12, L, 8, L, 4, L, 4,
# B = L, 8, R, 6, L, 6,·
# A = R, 12, L, 8, L, 4, L, 4,
# B = L, 8, R, 6, L, 6,
# C = L, 8, L, 4, R, 12, L, 6, L, 4,
# A = R, 12, L, 8, L, 4, L, 4,
# C = L, 8, L, 4, R, 12, L, 6, L, 4,
# A = R, 12, L, 8, L, 4, L, 4,
# C = L, 8, L, 4, R, 12, L, 6, L, 4,
# B = L, 8 , R, 6, L, 6

a = ad.encoding(["R", 12, "L", 8, "L", 4, "L", 4])
b = ad.encoding(["L", 8, "R", 6, "L", 6])
c = ad.encoding(["L", 8, "L", 4, "R", 12, "L", 6, "L", 4])

main = ad.encoding(["A","B","A","B","C","A","C","A","C","B"])

ad = Advent::Flare.new(input)
ad.program.instructions[0] = 2

(main + a + b + c).each do |inst|
  ad.program.program_input = inst
end

ad.program.program_input = "n".ord
ad.program.program_input = "\n".ord

ad.program.run!

ad.program.full_output.map do |out|
  if out > 255
    puts "\n#{out}\n"
  else
    print out.chr
  end
end
