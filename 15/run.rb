#!/usr/bin/env ruby

require_relative 'memory'

input = File.read('./input.txt')

ad = Advent::Memory.new(input)
