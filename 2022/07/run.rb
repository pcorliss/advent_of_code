#!/usr/bin/env ruby

require_relative 'filesystem'

input = File.read('./input.txt')

ad = Advent::Filesystem.new(input)
small_dirs = ad.find_small_dirs(100000)
puts small_dirs.sum(&:calc_size)

puts ad.find_directory_to_delete.calc_size