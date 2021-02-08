#!/usr/bin/env ruby

require_relative 'triangles'

input = File.read('./input.txt')

ad = Advent::Triangles.new(input)
