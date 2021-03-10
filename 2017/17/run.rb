#!/usr/bin/env ruby

require_relative 'spinlock'

input = File.read('./input.txt')

ad = Advent::Spinlock.new(input)
