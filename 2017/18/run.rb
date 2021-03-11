#!/usr/bin/env ruby

require_relative 'duet'

input = File.read('./input.txt')

ad = Advent::Duet.new(input)
