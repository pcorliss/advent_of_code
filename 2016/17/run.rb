#!/usr/bin/env ruby

require_relative 'vault'

input = File.read('./input.txt')

ad = Advent::Vault.new(input)
ad.debug!
path = ad.find_path
puts "Path: #{path}"

max_path = ad.find_path(false).map(&:length).max
puts "Path: #{max_path}"
