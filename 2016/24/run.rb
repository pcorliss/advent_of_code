#!/usr/bin/env ruby

require_relative 'hvac'

input = File.read('./input.txt')

ad = Advent::Hvac.new(input)
