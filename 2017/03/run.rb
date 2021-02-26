#!/usr/bin/env ruby

require_relative 'spiral'

input = File.read('./input.txt')

ad = Advent::Spiral.new(input)
