#!/usr/bin/env ruby

require_relative 'safecracking'

input = File.read('./input.txt')

ad = Advent::Safecracking.new(input)
