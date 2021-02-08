#!/usr/bin/env ruby

require_relative 'abba'

input = File.read('./input.txt')

ad = Advent::Abba.new(input)
cnt = ad.ips.count do |ip|
  ad.supports_tls?(ip)
end

puts "Supports TLS Count: #{cnt}"

cnt = ad.ips.count do |ip|
  ad.supports_ssl?(ip)
end
puts "Supports SSL Count: #{cnt}"
