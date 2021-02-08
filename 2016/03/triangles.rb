require 'set'
require '../lib/grid.rb'

module Advent

  class Triangles
    attr_accessor :debug
    attr_reader :triangles

    def initialize(input, use_rows = false)
      @debug = false
      @triangles = input.each_line.map do |line|
        line.chomp!
        line.lstrip.split(/\s+/).map(&:to_i)
      end
      if use_rows
        new_tri = []
        @triangles.each_with_index do |tri, idx|
          a, b, c = tri
          new_tri_pos = (idx / 3) * 3
          new_tri[new_tri_pos    ] ||= []
          new_tri[new_tri_pos + 1] ||= []
          new_tri[new_tri_pos + 2] ||= []

          new_tri[new_tri_pos    ] << a
          new_tri[new_tri_pos + 1] << b
          new_tri[new_tri_pos + 2] << c
        end

        @triangles = new_tri
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
