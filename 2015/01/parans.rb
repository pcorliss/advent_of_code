require 'set'
require '../lib/grid.rb'

module Advent

  class Parans
    attr_accessor :debug
    attr_reader :parans

    def initialize(input)
      @debug = false
      @parans = input.chomp.chars
    end

    def debug!
      @debug = true
    end

    def floor
      @parans.inject(0) do |acc, p|
        case p
        when ')'
          acc -= 1
        when '('
          acc += 1
        else
          raise "Unrecognized char: #{p}"
        end
      end
    end

    def first_basement
      acc = 0
      i = @parans.index do |p|
        case p
        when ')'
          acc -= 1
        when '('
          acc += 1
        else
          raise "Unrecognized char: #{p}"
        end
        acc == -1
      end
      i + 1
    end
  end
end
