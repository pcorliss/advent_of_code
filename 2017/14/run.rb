#!/usr/bin/env ruby

require_relative 'defrag'

input = File.read('./input.txt')

ad = Advent::Defrag.new(input)
