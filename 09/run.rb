#!/usr/bin/env ruby

require_relative 'crypt'

input = File.read('./input.txt')

ad = Advent::Crypt.new(input)
