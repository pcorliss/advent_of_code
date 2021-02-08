#!/usr/bin/env ruby

require_relative 'md5door'

input = File.read('./input.txt')

ad = Advent::Md5door.new(input)
