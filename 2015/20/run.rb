#!/usr/bin/env ruby

require_relative 'presents'

input = File.read('./input.txt')

ad = Advent::Presents.new(input)
