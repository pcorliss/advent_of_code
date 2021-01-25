#!/usr/bin/env ruby

require_relative 'knights'

input = File.read('./input.txt')

ad = Advent::Knights.new(input)
