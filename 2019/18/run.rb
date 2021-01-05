#!/usr/bin/env ruby

require_relative 'maze'

input = File.read('./input.txt')

ad = Advent::Maze.new(input)
