#!/usr/bin/env ruby

require_relative 'donut'

input = File.read('./input.txt')

ad = Advent::Donut.new(input)
