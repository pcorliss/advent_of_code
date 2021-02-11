require 'set'
require '../lib/grid.rb'
require 'digest'

module Advent

  class Onetime
    attr_accessor :debug
    attr_reader :salt, :candidates, :keys

    KEYS_IN_PAD = 64
    TRIPLE_REGEX = /(.)\1{2,}/

    def initialize(input)
      @debug = false
      @salt = input.chomp
      @md5 = Digest::MD5.new
      @candidates = []
      @keys = []
      @pos = 0
    end

    def md5(msg)
      @md5.reset
      @md5 << @salt
      @md5 << msg
      @md5.hexdigest
    end

    def debug!
      @debug = true
    end

    IDX = 0
    CHAR = 1
    HASH = 2

    def find_keys(n)
      (@pos...(@pos + n)).each do |i|
        @candidates.delete_at(0) if !@candidates.empty? && @candidates.first[IDX] + 1000 < i
        m = md5(i.to_s)
        if m =~ TRIPLE_REGEX
          (@candidates.length - 1).downto(0).each do |idx|
            if m.include? (@candidates[idx][CHAR] * 5)
              @keys << @candidates[idx]
              @candidates.delete_at(idx)
            end
          end
          @candidates << [i, $1, m]
        end
      end
      
      @pos += n
    end
  end
end
