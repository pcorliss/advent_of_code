#!/usr/bin/env ruby

require_relative 'shuffle'

input = File.read('./input.txt')

ad = Advent::Shuffle.new(input)
