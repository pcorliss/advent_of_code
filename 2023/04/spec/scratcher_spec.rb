require './scratcher.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Card  1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card  2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card  3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card  4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card  5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card  6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    EOS
  }

  describe Advent::Scratcher do
    let(:ad) { Advent::Scratcher.new(input) }

    describe "#new" do
      it "parses the input" do
        expect(ad.cards.count).to eq(6)
        expect(ad.cards.first.winners).to contain_exactly(41, 48, 83, 86, 17)
        expect(ad.cards.first.yours).to contain_exactly(83,86,6,31,17,9,48,53)
      end
    end

    describe "#score" do
      [8, 2, 2, 1, 0, 0].each_with_index do |score, idx|
        it "returns the score #{score} for a card #{idx + 1}" do
          expect(ad.score(ad.cards[idx])).to eq(score)
        end
      end
    end

    describe "#copy_cards!" do
      [1, 2, 4, 8, 14, 1].each_with_index do |copies, idx|
        it "populates the card copy counter for card #{idx + 1} and sets it to #{copies}" do
          ad.copy_cards!
          expect(ad.cards[idx].copies).to eq(copies)
        end
      end
    end

    context "validation" do
      it "returns the sum of scores for part 1" do
        expect(ad.score_sum).to eq(13)
      end

      it "returns the count of copied cards for part 2" do
        expect(ad.copied_card_count).to eq(30)
      end
    end
  end
end
