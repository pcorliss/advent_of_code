#!/usr/bin/env ruby

require_relative 'assembly'

input = File.read('./input.txt')

ad = Advent::Assembly.new(input)
