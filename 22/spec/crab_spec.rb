require '../crab.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
    EOS
  }

  describe Advent::Crab do
    let(:ad) { Advent::Crab.new(input) }

    describe "#new" do
      it "inits two decks" do
        expect(ad.decks.first).to eq([9,2,6,3,1])
        expect(ad.decks.last).to eq([5,8,4,7,10])
      end
    end

    describe "#round!" do
      it "incremnts the round counter" do
        expect { ad.round! }.to change { ad.round }.by(1)
      end

      it "orders the cards on the 1st player's deck correctly" do
        ad.round!
        expect(ad.decks.first).to eq([2,6,3,1,9,5])
        expect(ad.decks.last).to eq([8,4,7,10])
      end

      it "orders the cards on the 2nd player's deck correctly" do
        ad.round!
        ad.round!
        expect(ad.decks.first).to eq([6,3,1,9,5])
        expect(ad.decks.last).to eq([4,7,10,8,2])
      end
    end

    describe "#combat!" do
      it "runs until one player's deck is empty" do
        ad.combat!
        expect(ad.decks.first).to be_empty
        expect(ad.decks.last.count).to eq(10)
      end
    end

    describe "#score" do
      it "calculates the correct score" do
        ad.combat!
        expect(ad.score).to eq(306)
      end
    end

    context "validation" do
    end
  end
end
