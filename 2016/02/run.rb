#!/usr/bin/env ruby

require_relative 'security'

input = File.read('./input.txt')

ad = Advent::Security.new(input)
