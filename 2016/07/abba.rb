require 'set'
require '../lib/grid.rb'

module Advent

  class Abba
    attr_accessor :debug
    attr_reader :ips

    def initialize(input)
      @debug = false
      @ips = input.each_line.map(&:chomp)
    end

    def debug!
      @debug = true
    end

    def abba?(str)
      !palindrome?(str, 4).empty?
    end

    def aba(str)
      palindrome?(str, 3)
    end

    def bab?(str, sequences)
      puts "Hypernet: #{str}" if @debug
      puts "Sequences: #{sequences}" if @debug
      sequences.any? do |chars|
        puts "Inc: #{chars.last + chars.first + chars.last} in #{str}" if @debug
        i = str.include?(chars.last + chars.first + chars.last)
        puts "Match: #{chars} #{str}" if i && @debug
        i
      end
    end

    # kinda a palindrome, needs a better name
    def palindrome?(str, len)
      pos = len - 1
      sequences = []
      while pos < str.length do
        chars = str[(pos - len + 1)..pos].chars
        j = 0
        palin = true
        while j < len / 2 do
          if chars[j] != chars[len - j - 1]
            palin = false
            break
          end
          j += 1
        end

        sequences << [chars.first, chars[1]] if palin && chars[0] != chars[1]
        pos += 1
      end
      sequences
    end

    def decompose_ip(str)
      seq = ""
      segments = []
      nonhyper = []
      hypernet = []
      str.each_char do |char|
        if char == '['
          segments << seq
          nonhyper << seq
          seq = ""
          next
        end
        if char == ']'
          segments << seq
          hypernet << seq
          seq = ""
          next
        end
        seq << char
      end
      segments << seq
      nonhyper << seq

      {
        segments: segments,
        nonhyper: nonhyper,
        hypernet: hypernet,
      }
    end

    def supports_tls?(str)
      decomposed = decompose_ip(str)
      # decomposed[:nonhyper].any? { |segment| abba?(segment) } && !decomposed[:hypernet].any? { |segment| abba?(segment) }
      decomposed[:nonhyper].any? { |segment| abba?(segment) } && decomposed[:hypernet].all? { |segment| !abba?(segment) }
    end

    def supports_ssl?(str)
      decomposed = decompose_ip(str)
      aba_segments = []
      decomposed[:nonhyper].map { |segment| aba_segments.concat aba(segment) }
      puts "Segments: #{aba_segments}" if @debug
      return false if aba_segments.empty?
      decomposed[:hypernet].any? { |segment| bab?(segment, aba_segments) }
    end
  end
end
