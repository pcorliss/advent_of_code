#!/usr/bin/env ruby

require_relative 'virus'

input = File.read('./input.txt')

ad = Advent::Virus.new(input)
