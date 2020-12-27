require 'set'

module Advent

  class Crab
    attr_reader :decks, :round

    def initialize(input, deck_a = [], deck_b = [])
      @previously_seen = Set.new
      @decks = [deck_a, deck_b]
      @round = 0
      player = 0
      return if !deck_a.empty? && !deck_b.empty?
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

    def combat!(recurse = false)
      until @decks.any?(&:empty?) do
        if recurse
          if @previously_seen.include? @decks
            # puts "\tPreviously seen this deck, marking player 1 as winner of game"
            # require 'pry'
            # binding.pry
            break
            # card_a = @decks.first.shift
            # card_b = @decks.last.shift
            # @decks.first.concat [card_a, card_b]
            # @round += 1
            # return
          else
            @previously_seen.add @decks.map(&:clone)
          end
          recursive_round!
        else
          round!
        end
        raise "Max Iterations reached" if @round > 1000000
      end
    end

    def winner
      recursive_combat!
      return 0 if !@decks.first.empty? && !@decks.last.empty?
      return 1 if @decks.first.empty?
      return 0 if @decks.last.empty?
      return nil
    end

    def recursive_round!
      # puts "#{round + 1} - Decks: #{@decks}"
      # binding.pry if round == 8
      if @decks.all? { |deck| deck.first < deck.length }
        # puts "\tRecursive Round Verified"
        card_a = @decks.first.shift
        card_b = @decks.last.shift

        subgame = Advent::Crab.new("", @decks.first.first(card_a), @decks.last.first(card_b))
        winner = subgame.winner
        ordering = [card_a, card_b]
        ordering.reverse! if winner == 1
        @round += 1
        @decks[winner].concat ordering
      else
        round!
      end
    end

    def recursive_combat!
      combat!(true)
      # puts "\tGame Complete After #{@round + 1}"
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
