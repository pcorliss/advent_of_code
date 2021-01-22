require 'set'
require '../lib/grid.rb'

module Advent

  class Policy
    attr_accessor :debug
    attr_reader :password

    def initialize(input)
      @debug = false
      @password = input.chomp
    end

    def debug!
      @debug = true
    end

    # TODO: Add a skip here to jump over the banned letters in DENY_REGEX
    def next_password(pw)
      l = pw.length
      pos = l - 1

      next_pw = pw.dup
      loop do
        if pos < 0
          next_pw = "a" + next_pw
          break
        elsif next_pw[pos] != 'z'
          next_pw[pos] = (next_pw[pos].ord + 1).chr
          next_pw[pos] = (next_pw[pos].ord + 1).chr if DENY_LETTERS.include? next_pw[pos]
          break
        else
          next_pw[pos] = 'a'
          pos -= 1
        end
      end
      next_pw
    end

    SEQUENCE_REGEX = /abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz/
    DENY_REGEX = /^[^iol]*$/
    DENY_LETTERS = ['i','o','l']

    def valid?(pw)
      return false unless pw.match(SEQUENCE_REGEX) && pw.match(DENY_REGEX)

      pairs = Set.new
      i = 0
      while i < pw.length - 1
        if pw[i] == pw[i + 1]
          pairs.add pw[i]
          return true if pairs.length > 1
        end
        i += 1
      end

      false
    end

    def next_valid_password(pw)
      next_pw = pw
      i = 0
      until i > 0 && valid?(next_pw) do
        next_pw = next_password(next_pw)
        puts "Next:\t#{i}\t#{next_pw}" if @debug && i % 100000 == 0
        i += 1
      end
      next_pw
    end
  end
end
