#!/usr/bin/env ruby

require_relative 'compress'

input = File.read('./input.txt')

ad = Advent::Compress.new(input)
