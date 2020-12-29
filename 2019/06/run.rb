#!/usr/bin/env ruby

require_relative 'orbit'

input = File.read('./input.txt')

ad = Advent::Orbit.new(input)
