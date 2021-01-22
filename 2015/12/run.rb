#!/usr/bin/env ruby

require_relative 'accounting'

input = File.read('./input.txt')

ad = Advent::Accounting.new(input)
