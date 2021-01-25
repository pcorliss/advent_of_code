require 'set'
require '../lib/grid.rb'

module Advent

  class Knights
    attr_accessor :debug
    attr_reader :guests, :happy_map

    def initialize(input)
      @debug = false
      @happy_map = {}
      input.each_line do |line|
        line.chomp!
        #Alice would gain 54 happiness units by sitting next to Bob.
        if line =~ /^(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+).$/
          a = $1
          b = $4
          direction = $2
          quantity = $3.to_i
          quantity *= -1 if direction == 'lose'
          @happy_map[a] ||= {}
          @happy_map[a][b] = quantity
        end
      end
      @guests = @happy_map.keys
    end

    def debug!
      @debug = true
    end

    def sum_happiness(configuration)
      l = configuration.length
      sum = 0
      configuration.each_with_index do |person, idx|
        left = configuration[(idx - 1) % l]
        right = configuration[(idx + 1) % l]
        sum += @happy_map[person][left]
        sum += @happy_map[person][right]
      end
      sum
    end

    def optimal
      @guests.permutation.max_by do |config|
        sum_happiness(config)
      end
    end
  end
end
