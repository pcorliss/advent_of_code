require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  # Opponent
  # A for Rock, B for Paper, and C for Scissors
  # Your
  # X for Rock, Y for Paper, and Z for Scissors.

  # Your selection
  # 1 for Rock, 2 for Paper, and 3 for Scissors
  # 0 if you lost, 3 if the round was a draw, and 6 if you won

  class Rps
    attr_accessor :debug
    attr_reader :rounds

    SELECTION_SCORE = {
      'X' => 1,
      'Y' => 2,
      'Z' => 3,
    }

    WIN = 6
    LOSE = 0
    DRAW = 3

    # From your perspective (second)
    WIN_LOSE_DRAW = {
      ['A', 'X'] => DRAW,
      ['B', 'Y'] => DRAW,
      ['C', 'Z'] => DRAW,
      ['C', 'X'] => WIN,
      ['A', 'Y'] => WIN,
      ['B', 'Z'] => WIN,
      ['B', 'X'] => LOSE,
      ['C', 'Y'] => LOSE,
      ['A', 'Z'] => LOSE,
    }

    def initialize(input)
      @debug = false
      @rounds = []
      input.each_line do |line|
        line.chomp!
        a, b = line.split(' ')
        @rounds.push [a, b]
      end
    end

    def debug!
      @debug = true
    end

    def play_round(round)
      [
        SELECTION_SCORE[round[1]],
        WIN_LOSE_DRAW[round],
      ]
    end

    def score_round(round)
      play_round(round).sum
    end

    def play
      rounds.sum do |r|
        score_round(r)
      end
    end
  end
end
