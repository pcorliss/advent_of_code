#!/usr/bin/env ruby

require_relative 'packages'

input = File.read('./input.txt')

ad = Advent::Packages.new(input)
config = ad.configurations.min_by do |config|
  config.inject(:*)
end
puts "QE: #{config} #{config.inject(:*)}"

ad = Advent::Packages.new(input)
config = ad.configurations(4).min_by do |config|
  config.inject(:*)
end
puts "QE: #{config} #{config.inject(:*)}"
