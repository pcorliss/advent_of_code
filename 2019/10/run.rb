#!/usr/bin/env ruby

require_relative 'monitoring'

input = File.read('./input.txt')

ad = Advent::Monitoring.new(input)
