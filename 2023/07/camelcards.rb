require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  Hand = Struct.new(:cards, :bid)

  class Camelcards
    attr_accessor :debug
    attr_reader :hands

    def initialize(input)
      @debug = false
      @hands = input.lines.map do |line|
        cards, bid = line.split
        Hand.new(cards, bid.to_i)
      end
    end

    def debug!
      @debug = true
    end

    CARD_VALUE_MAP = {
      'A' => 14,
      'K' => 13,
      'Q' => 12,
      'J' => 11,
      'T' => 10,
    }

    def score(hand)
      card_counts = hand.chars.group_by(&:itself).values.map(&:count).sort.reverse

      card_vals = hand.chars.map do |c|
        val = CARD_VALUE_MAP[c] ?  CARD_VALUE_MAP[c] : c.to_i
        sprintf("%02d", val)
      end

      card_vals_float = card_vals.join('').to_i

      hand_val = if card_counts == [5]
        7.0
      elsif card_counts == [4, 1]
        6.0
      elsif card_counts == [3, 2]
        5.0
      elsif card_counts == [3, 1, 1]
        4.0
      elsif card_counts == [2, 2, 1]
        3.0
      elsif card_counts == [2, 1, 1, 1]
        2.0
      else
        1.0
      end

      [hand_val, card_vals_float]
    end

    def hand_sort
      @hands.sort_by do |hand|
        score(hand.cards)
      end
    end

    def total_winnings
      hand_sort.each_with_index.sum do |hand, idx|
        hand.bid * (idx + 1)
      end
    end
  end
end
