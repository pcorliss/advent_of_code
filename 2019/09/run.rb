#!/usr/bin/env ruby

require_relative 'sensor'

input = File.read('./input.txt')

ad = Advent::Sensor.new(input)
