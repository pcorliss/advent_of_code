#!/usr/bin/env ruby

require_relative 'policy'

input = File.read('./input.txt')

ad = Advent::Policy.new(input)
