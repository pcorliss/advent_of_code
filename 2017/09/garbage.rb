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

      s.each_char do |char|
        if garbage && bang
          bang = false
          next
        end
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
        when '<'
          garbage = true
        when '>'
          garbage = false
        end
      end

      acc
    end
  end
end
