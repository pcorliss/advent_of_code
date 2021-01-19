require 'set'
require '../lib/grid.rb'

module Advent

  class Wrapping
    attr_accessor :debug
    attr_reader :presents

    def initialize(input)
      @debug = false
      @presents = input.each_line.map do |line|
        line.chomp!
        line.split('x').map(&:to_i)
      end
    end

    def debug!
      @debug = true
    end

    def paper(dims)
      l, w, h = dims
      a = l * w
      b = w * h
      c = l * h
      min = [a,b,c].min

      min + 2*a + 2*b + 2*c
    end

    def total_paper
      @presents.sum do |p|
        paper(p)
      end
    end
  end
end
