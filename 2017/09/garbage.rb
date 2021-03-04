require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Garbage
    attr_accessor :debug
    attr_reader :str

    def initialize(input)
      @debug = false
      @str = input.chomp
    end

    def debug!
      @debug = true
    end

    def score(s)
      acc = 0
      depth = 0
      bang = false
      garbage = false
      garbage_chars = 0

      s.each_char do |char|
        if garbage && bang
          bang = false
          next
        end
        garbage_chars += 1 if garbage
        case char
        when '{'
          next if garbage
          depth += 1
          acc += depth
        when '}'
          next if garbage
          depth -= 1
        when '!'
          bang = true
          garbage_chars -= 1
        when '<'
          garbage = true
        when '>'
          garbage = false
          garbage_chars -= 1
        end
      end

      [acc, garbage_chars]
    end
  end
end
