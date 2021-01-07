#!/usr/bin/env ruby

require_relative 'tractor'

input = File.read('./input.txt')

ad = Advent::Tractor.new(input)
