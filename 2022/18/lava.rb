require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Lava
    attr_accessor :debug
    attr_reader :cubes

    def initialize(input)
      @debug = false
      @cubes = input.each_line.map do |line|
        line.chomp!
        line.split(',').map(&:to_i)
      end
    end

    def debug!
      @debug = true
    end

    def exposed_sides
      matched_sides = 0
      @cubes.combination(2) do |a, b|
        a_x, a_y, a_z = a
        b_x, b_y, b_z = b

        if (a_x - b_x).abs + (a_y - b_y).abs + (a_z - b_z).abs == 1
          matched_sides += 1
          puts "Adjacent: #{a}, #{b}" if @debug
        end
      end

      (@cubes.count * 6) - matched_sides * 2
    end
  end
end
