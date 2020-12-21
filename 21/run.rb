#!/usr/bin/env ruby

require_relative 'allergen'

input = File.read('./input.txt')

ad = Advent::Allergen.new(input)
