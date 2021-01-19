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
  end
end
