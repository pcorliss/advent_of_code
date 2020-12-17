#!/usr/bin/env ruby

require_relative 'cubes'

input = File.read('./input.txt')

ad = Advent::Cubes.new(input)
