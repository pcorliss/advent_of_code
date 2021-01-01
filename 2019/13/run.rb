#!/usr/bin/env ruby

require_relative 'arcade'

input = File.read('./input.txt')

ad = Advent::Arcade.new(input)
