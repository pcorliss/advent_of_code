require 'set'
require '../lib/grid.rb'

module Advent

  class Triangles
    attr_accessor :debug
    attr_reader :triangles

    def initialize(input)
      @debug = false
      @triangles = input.each_line.map do |line|
        line.chomp!
        line.lstrip.split(/\s+/).map(&:to_i)
      end
    end

    def debug!
      @debug = true
    end

    def valid?(triangle)
      a, b, c = triangle.sort
      a + b > c
    end
  end
end
