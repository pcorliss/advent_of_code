#!/usr/bin/env ruby

require_relative 'screen'

input = File.read('./input.txt')

ad = Advent::Screen.new(input)
