require 'set'
require '../lib/grid.rb'

module Advent

  class Naughty
    attr_accessor :debug
    attr_reader :list

    def initialize(input)
      @debug = false
      @list = input.lines.map(&:chomp)
    end

    def debug!
      @debug = true
    end

    VOWELS = Set.new('aeiou'.chars)
    FORBIDDEN = Set.new(%w(ab cd pq xy))

    def nice?(str)
      vowels_seen = 0
      prev_char = nil
      seen_dupe = false
      str.each_char do |char|
        vowels_seen += 1 if VOWELS.include? char

        return false if prev_char && FORBIDDEN.include?(prev_char + char)

        seen_dupe = true if prev_char == char
        prev_char = char
      end

      vowels_seen >= 3 && seen_dupe
    end

    def nice_count
      @list.count { |str| nice?(str) }
    end

    def super_nice?(str)
      letter_between = false
      pairs = {}
      prev_char = nil
      str.chars.each_with_index do |char, idx|
        letter_between = true if idx > 1 && char == str[idx - 2]

        if prev_char
          pairs[prev_char + char] ||= []
          pairs[prev_char + char] << idx
        end
        prev_char = char
      end

      repeats = pairs.any? do |char, indexes|
        if indexes.count > 1
          min, max = indexes.minmax
          (max - min) > 1
        end
      end
      letter_between && repeats
    end

    def super_nice_count
      @list.count { |str| super_nice?(str) }
    end
  end
end
