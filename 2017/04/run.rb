#!/usr/bin/env ruby

require_relative 'passphrase'

input = File.read('./input.txt')

ad = Advent::Passphrase.new(input)
valid_phrases = ad.phrases.count { |phrase| ad.valid?(phrase) }
puts "Valid: #{valid_phrases} out of #{ad.phrases.count}"
valid_phrases = ad.phrases.count { |phrase| ad.valid_anagram?(phrase) }
puts "Valid: #{valid_phrases} out of #{ad.phrases.count}"
