#!/usr/bin/env ruby

require_relative 'police'

input = File.read('./input.txt')

ad = Advent::Police.new(input)
