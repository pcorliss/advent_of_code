require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Tuning
    attr_accessor :debug
    attr_reader :buffer

    def initialize(input)
      @debug = false
      @buffer = input.chomp
    end

    def debug!
      @debug = true
    end

    def marker
      buffer.chars.each_cons(4).each_with_index do |chars, idx|
        return idx + 4 if chars.uniq.count == 4
      end
    end
  end
end
