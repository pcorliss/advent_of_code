require 'set'
require '../lib/grid.rb'

module Advent

  class Dragon
    attr_accessor :debug
    attr_reader :inp

    def initialize(input)
      @debug = false
      @inp = input.chomp
    end

    def debug!
      @debug = true
    end

    def dragon(a, length = nil)
      loop do
        b = a.reverse.tr('01','10')
        a = a + "0" + b
        break if length.nil? || a.length >= length
      end

      a = a[0...length] if length
      a
    end

    def checksum(input)
      result = input.chars
      loop do
        result = result.each_slice(2).map do |a,b|
          a == b ? '1' : '0'
        end
        break if result.count.odd?
      end
      result.join
    end
  end
end
