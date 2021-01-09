#!/usr/bin/env ruby

require_relative 'spring'

input = File.read('./input.txt')
spring_script = <<~EOS
NOT A J
NOT B T
OR T J
NOT C T
OR T J
AND D J
  EOS

ad = Advent::Spring.new(input)
ad.write_program(spring_script)
print ad.run_and_output
