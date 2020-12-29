#!/usr/bin/env ruby

require_relative 'amp'

input = File.read('./input.txt')

ad = Advent::Amp.new(input)
puts "Ideal Phase: #{ad.ideal_phase_setting}"
puts "Max Thruster: #{ad.max_thruster_signal}"

ad = Advent::LoopedAmp.new(input)
puts "Ideal Phase: #{ad.ideal_phase_setting}"
puts "Max Thruster: #{ad.max_thruster_signal}"
