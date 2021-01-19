require 'set'
require 'digest'
require '../lib/grid.rb'

module Advent

  class AdventCoins
    attr_accessor :debug
    attr_reader :secret

    def initialize(input, zeroes = 5)
      @debug = false
      @secret = input.chomp
      @start = '0' * zeroes
    end

    def debug!
      @debug = true
    end

    def next_coin
      @counter ||= -1
      loop do
        @counter += 1
        digest = Digest::MD5.hexdigest(secret + @counter.to_s)
        return @counter if digest.start_with? @start
      end
    end
  end
end
