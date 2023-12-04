require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  Card = Struct.new(:id, :winners, :yours, :copies)

  class Scratcher
    attr_accessor :debug
    attr_reader :cards

    def initialize(input)
      @debug = false
      @cards = input.each_line.map do |line|
        parse_line(line)
      end
    end

    def parse_line(line)
      line.chomp!
      line =~ /^Card\s+(\d+):\s+(.*)\s+\|\s+(.*)$/
      id = $1.to_i
      winners = $2.split.map(&:to_i)
      yours = $3.split.map(&:to_i)
      Card.new(id, winners, yours, 1)
    end

    def score(card)
      matching_nums = (card.winners.to_set & card.yours.to_set).count
      return 0 if matching_nums == 0
      2 ** (matching_nums - 1)
    end

    def score_sum
      @cards.sum { |c| score(c) }
    end

    def copy_cards!
      @cards.each_with_index do |card, idx|
        matches = (card.winners.to_set & card.yours.to_set).count
        matches.times do |i|
          break if @cards[idx + i + 1].nil?
          @cards[idx + i + 1].copies += card.copies
        end
      end
    end

    def copied_card_count
      copy_cards!
      @cards.sum(&:copies)
    end

    def debug!
      @debug = true
    end
  end
end
