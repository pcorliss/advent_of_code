#!/usr/bin/env ruby

require_relative 'rules'

input = File.read('./input.txt')

ad = Advent::Rules.new(input)
