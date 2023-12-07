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

      card_vals = card_vals.join('').to_i

      hand_val = if card_counts == [5]
        7
      elsif card_counts == [4, 1]
        6
      elsif card_counts == [3, 2]
        5
      elsif card_counts == [3, 1, 1]
        4
      elsif card_counts == [2, 2, 1]
        3
      elsif card_counts == [2, 1, 1, 1]
        2
      else
        1
      end

      [hand_val, card_vals]
    end

    CARD_VALUE_MAP_2 = {
      'A' => 14,
      'K' => 13,
      'Q' => 12,
      'J' => 01,
      'T' => 10,
    }

    def score_2(hand)
      puts "Scoring: #{hand}" if @debug
      hand_without_wilds = hand.gsub('J', '')
      card_counts = hand_without_wilds.chars.group_by(&:itself).values.map(&:count).sort.reverse

      card_vals = hand.chars.map do |c|
        val = CARD_VALUE_MAP_2[c] || c.to_i
        sprintf("%02d", val)
      end

      card_vals = card_vals.join('').to_i

      # All Jokers Exception
      return [7, card_vals] if card_counts.empty?
      
      card_counts[0] += hand.chars.count('J')

      hand_val = if card_counts.first == 5
        7
      elsif card_counts.first == 4
        6
      elsif card_counts.first(2) == [3,2]
        5
      elsif card_counts.first == 3
        4
      elsif card_counts.first(2) == [2,2]
        3
      elsif card_counts.first == 2
        2
      else
        1
      end

      [hand_val, card_vals]
    end

    def hand_sort
      @hands.sort_by do |hand|
        score(hand.cards)
      end
    end

    def hand_sort_2
      @hands.sort_by do |hand|
        score_2(hand.cards)
      end
    end

    def total_winnings
      hand_sort.each_with_index.sum do |hand, idx|
        hand.bid * (idx + 1)
      end
    end

    def total_winnings_2
      hand_sort_2.each_with_index.sum do |hand, idx|
        hand.bid * (idx + 1)
      end
    end
  end
end
