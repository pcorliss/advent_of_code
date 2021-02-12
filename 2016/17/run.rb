#!/usr/bin/env ruby

require_relative 'vault'

input = File.read('./input.txt')

ad = Advent::Vault.new(input)
ad.debug!
path = ad.find_path
puts "Path: #{path}"
