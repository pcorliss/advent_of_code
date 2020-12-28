#!/usr/bin/env ruby

require_relative 'asteroids'

input = File.read('./input.txt')

ad = Advent::Asteroids.new(input)
