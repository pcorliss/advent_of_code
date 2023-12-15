require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Lens
    attr_accessor :debug
    attr_reader :commands

    def initialize(input)
      @debug = false
      @commands = input.chomp.split(',')
    end

    def debug!
      @debug = true
    end

    def hashing(str)
      str.each_char.inject(0) do |val, c|
        val += c.ord
        val *= 17
        val %= 256
      end
    end

    def command_hash_sum
      @commands.sum{ |c| hashing(c) }
    end
  end
end
