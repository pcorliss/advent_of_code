#!/usr/bin/env ruby

require_relative 'firewall'

input = File.read('./input.txt')

ad = Advent::Firewall.new(input)
sev = ad.severity
puts "Severity: #{sev}"

ad.debug!
offset = ad.find_stealth_offset
puts "Offset: #{offset}"

# 213924 is too low
