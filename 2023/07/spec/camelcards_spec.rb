require './camelcards.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    EOS
  }

  describe Advent::Camelcards do
    let(:ad) { Advent::Camelcards.new(input) }

    describe "#new" do
      it "loads the input and parses it" do
        expect(ad.hands.count).to eq(5)
        expect(ad.hands.first.cards).to eq('32T3K')
        expect(ad.hands.first.bid).to eq(765)
      end
    end

    describe "score" do
      {
        '55555' => 7, # 5 of a kind
        '44A44' => 6, # 4 of a kind
        '23233' => 5, # full house
        '323A3' => 4, # 3 of a kind
        'A2AT2' => 3, # 2 pair
        'A2343' => 2, # 1 pair
        '23456' => 1, # high card
      }.each do |hand, expected_score|
        it "returns the hand score #{expected_score} for a hand #{hand} as the integer component" do
          expect(ad.score(hand).first).to eq(expected_score)
        end
      end

      it "returns the float component to represent the hand value for sorting" do
        expect(ad.score('AKQJT').last).to eq(1413121110)
        expect(ad.score('98765').last).to eq( 908070605)
        expect(ad.score('43222').last).to eq( 403020202)
      end
    end

    describe "#hand_sort" do
      it "returns hands in order of score" do
        expect(ad.hand_sort.map(&:cards)).to eq([
          '32T3K', #1
          'KTJJT',
          'KK677',
          'T55J5',
          'QQQJA', #5
        ])
      end
    end

    describe "#total_winnings" do
      it "returns the total winnings, hand rank * bid sum" do
        expect(ad.total_winnings).to eq(6440)
      end
    end

    context "validation" do
    end
  end
end
