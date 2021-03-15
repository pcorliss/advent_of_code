#!/usr/bin/env ruby

require_relative 'fractal'

input = File.read('./input.txt')

ad = Advent::Fractal.new(input)
