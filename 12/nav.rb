require 'set'

module Advent

  class Nav2
    attr_reader :pos, :moves, :way
    def initialize(input)
      @moves = input.lines.map(&:chomp)
      @pos = [0,0]
      @way = [10,1]
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
          @way[1] += n
        when 'S'
          @way[1] -= n
        when 'W'
          @way[0] -= n
        when 'E'
          @way[0] += n
        when 'R'
          (n / 90).times do
            n = @way[0]
            @way[0] = @way[1]
            @way[1] = -n
          end
          # 10,4
          # 4,-10
          # -10,-4
          # -4,10
        when 'L'
          move!("R#{-n % 360}")
        when 'F'
          # move!(CARD[@direction] + n.to_s)
          @pos[0] += @way[0] * n
          @pos[1] += @way[1] * n
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
