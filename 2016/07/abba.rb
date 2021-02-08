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

    def contains_abba?(str)
      pos = 3
      while pos < str.length do
        a, b, c, d = str[(pos - 3)..pos].chars
        return true if a == d && b == c && a != b
        pos += 1
      end
      false
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
      decomposed[:nonhyper].any? { |segment| contains_abba?(segment) } && decomposed[:hypernet].all? { |segment| !contains_abba?(segment) }
    end
  end
end
