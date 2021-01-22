#!/usr/bin/env ruby

require_relative 'shortest'

input = File.read('./input.txt')

ad = Advent::Shortest.new(input)
