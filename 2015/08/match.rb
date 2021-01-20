require 'set'
require '../lib/grid.rb'

module Advent

  class Match
    attr_accessor :debug
    attr_reader :strings

    def initialize(input)
      @debug = false
      @strings = input.lines.map(&:chomp)
    end

    def debug!
      @debug = true
    end

    def code_length(str)
      str.length
    end

    def cheating_string_length(str)
      eval(str).length
    end

    def string_length(str)
      max = str.length - 2
      backslash = false
      l = 0
      (1..max).each do |idx|
        char = str[idx]
        puts "C: #{char} #{backslash}" if @debug
        l -= 1 if backslash && char == '\\' || char == '"'
        l -= 3 if backslash && char == 'x'
        backslash = char == '\\' && !backslash
        puts "\tBack: #{backslash}" if @debug
        # backslash = char == '\\'
        l += 1
      end
      l
    end

    def total_code_minus_str
      @strings.sum do |str|
        code_length(str) - string_length(str)
      end
    end
  end
end
