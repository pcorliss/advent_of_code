#!/usr/bin/env ruby

require_relative 'discs'

input = File.read('./input.txt')

ad = Advent::Discs.new(input)
