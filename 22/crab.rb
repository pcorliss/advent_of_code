require 'set'

module Advent

  class Crab
    attr_reader :decks, :round

    def initialize(input)
      @decks = []
      @round = 0
      player = 0
      input.each_line do |line|
        line.chomp!
        # puts "L: #{line}"
        case line
        when /^Player/
          player += 1
        when /^\d+/
          @decks[player - 1] ||= []
          @decks[player - 1] << line.to_i
        end
      end
    end

    def round!
      @round += 1
      max = 0
      round_cards = @decks.map do |d|
        card = d.shift
        max = card if card > max
        card
      end
      # puts "Max: #{max} #{round_cards.index(max)} #{round_cards} #{@decks}"
      @decks[round_cards.index(max)].concat round_cards.sort.reverse
    end

    def combat!
      until @decks.any?(&:empty?) do
        round!
        raise "Max Iterations reached" if @round > 1000
      end
    end

    def score
      winning_deck = @decks.find { |d| !d.empty? }
      acc = 0
      winning_deck.reverse.each_with_index do |card, idx|
        acc += card * (idx + 1)
      end
      acc
    end
  end
end
