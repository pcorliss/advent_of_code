#!/usr/bin/env ruby

require_relative 'alarm'

input = File.read('./input.txt')

ad = Advent::Alarm.new(input)
puts "Start Instructions: #{ad.instructions}"
ad.instructions[1] = 12
ad.instructions[2] = 2
puts "Mod   Instructions: #{ad.instructions}"
ad.run!
puts "Post  Instructions: #{ad.instructions}"


(0..99).each do |noun|
  (0..99).each do |verb|
    ad = Advent::Alarm.new(input)
    ad.instructions[1] = noun
    ad.instructions[2] = verb
    ad.run!
    if ad.instructions[0] == 19690720
      puts "Noun: #{noun} Verb: #{verb}"
      puts "Total: #{100*noun + verb}"
      exit
    end
  end
end
