#!/usr/bin/env ruby

require_relative 'packages'

input = File.read('./input.txt')

ad = Advent::Packages.new(input)
