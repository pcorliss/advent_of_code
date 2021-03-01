require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Passphrase
    attr_accessor :debug
    attr_reader :phrases

    def initialize(input)
      @debug = false
      @phrases = input.each_line.map do |line|
        line.chomp!
        line.split(/\s+/)
      end
    end

    def debug!
      @debug = true
    end

    def valid?(phrase)
      Set.new(phrase).count == phrase.count
    end

    def valid_anagram?(phrase)
      s = Set.new
      phrase.each do |word|
        s.add word.chars.sort.to_a
      end
      s.count == phrase.count
    end
  end
end
