require 'set'

module Advent

  class Nav
    attr_reader :pos, :direction, :moves
    def initialize(input)
      @direction = 90
      @moves = input.lines.map(&:chomp)
      @pos = [0,0]
    end

    CARD = {
      0 => 'N',
      90 => 'E',
      180 => 'S',
      270 => 'W',
    }

    def move!(inst)
      if inst =~ /^(\w)(\d+)$/
        i = $1
        n = $2.to_i
        case i
        when 'N'
          @pos[1] += n
        when 'S'
          @pos[1] -= n
        when 'W'
          @pos[0] -= n
        when 'E'
          @pos[0] += n
        when 'R'
          @direction += n
          @direction %= 360
        when 'L'
          @direction -= n
          @direction %= 360
        when 'F'
          move!(CARD[@direction] + n.to_s)
        end
      end
    end

    def exec!
      @moves.each do |m|
        move!(m)
      end
    end

    def manhattan
      pos[0].abs + pos[1].abs
    end
  end
end
