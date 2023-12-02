require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Cubes
    attr_accessor :debug

    def initialize(input, possible)
      @debug = false
      @possible = possible
      @lines = input.each_line.map(&:strip)
    end

    def parse_line(line)
      game_id, games_str = line.split(':')
      games_str.split(';').map do |game_str|
        game_str.strip.split(',').map do |cube_str|
          count, color = cube_str.strip.split(' ')
          [color.to_sym, count.to_i]
        end.to_h
      end
    end

    def possible?(line)
      games = parse_line(line)
      games.all? do |game|
        game.all? do |color, count|
          @possible[color] >= count
        end
      end
    end

    def possible_game_sum
      @lines.each_with_index.sum do |line, idx|
        possible?(line) ? idx + 1 : 0
      end
    end

    def minimum_cubes(line)
      games = parse_line(line)
      games.inject({}) do |hsh, game|
        game.each do |color, count|
          hsh[color] ||= 0
          hsh[color] = count if count > hsh[color]
        end
        hsh
      end
    end

    def minimum_cubes_power(min)
      min.values.inject(:*)
    end

    def minimum_cubes_power_sum
      @lines.each.sum do |line|
        min = minimum_cubes(line)
        minimum_cubes_power(min)
      end
    end

    def debug!
      @debug = true
    end
  end
end
