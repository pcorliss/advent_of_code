#!/usr/bin/env ruby

require_relative 'cookie'

input = File.read('./input.txt')

ad = Advent::Cookie.new(input)
