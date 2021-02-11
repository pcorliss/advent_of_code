#!/usr/bin/env ruby

require_relative 'onetime'

input = File.read('./input.txt')

ad = Advent::Onetime.new(input)
