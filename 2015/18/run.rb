#!/usr/bin/env ruby

require_relative 'lights'

input = File.read('./input.txt')

ad = Advent::Lights.new(input)
