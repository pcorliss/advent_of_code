#!/usr/bin/env ruby

require_relative 'dancing'

input = File.read('./input.txt')

ad = Advent::Dancing.new(input)
