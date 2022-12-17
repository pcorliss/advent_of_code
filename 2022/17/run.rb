#!/usr/bin/env ruby

require_relative 'tetris'

input = File.read('./input.txt')

ad = Advent::Tetris.new(input)
