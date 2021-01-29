#!/usr/bin/env ruby

require_relative 'medicine'

input = File.read('./input.txt')

ad = Advent::Medicine.new(input)
