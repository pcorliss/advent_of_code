require 'set'
require 'digest'
require '../lib/grid.rb'

module Advent

  class Md5door
    attr_accessor :debug
    attr_reader :door

    def initialize(input)
      @debug = false
      @door = input.chomp
    end

    def debug!
      @debug = true
    end

    def gen_hash(idx, str)
      loop do
        h = Digest::MD5.hexdigest(str + idx.to_s)
        return [idx, h] if h.start_with? '00000'
        idx += 1
      end
    end

    def gen_pw
      idx = -1
      hashes = 8.times.map do
        idx, hash = gen_hash(idx + 1, @door)
        puts "#{idx} - #{hash} - #{hash[5]}" if @debug
        hash[5]
      end
      hashes.join
    end

    def gen_pw_with_pos
      idx = -1
      result = []
      loop do
        idx, hash = gen_hash(idx + 1, @door)
        pos = hash[5]
        val = hash[6]
        result[pos.to_i] ||= val if pos.ord < 97 && pos.to_i < 8
        puts "#{idx} - #{hash} - #{hash[5]} - #{hash[6]} - #{result}" if @debug
        return result.join if result.length >= 8 && !result.include?(nil)
      end
    end
  end
end
