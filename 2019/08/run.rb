#!/usr/bin/env ruby

require_relative 'image'

input = File.read('./input.txt')

ad = Advent::Image.new(input)
