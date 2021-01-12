#!/usr/bin/env ruby

require_relative 'packets'

input = File.read('./input.txt')

ad = Advent::Packets.new(input)
