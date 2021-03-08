#!/usr/bin/env ruby

require_relative 'firewall'

input = File.read('./input.txt')

ad = Advent::Firewall.new(input)
sev = ad.severity
puts "Severity: #{sev}"
