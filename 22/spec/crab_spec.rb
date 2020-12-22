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

      it "ignores input if the decks are passed directly" do
        ad = Advent::Crab.new(input, 3.times.to_a, 3.times.to_a)
        expect(ad.decks.first).to eq(3.times.to_a)
        expect(ad.decks.last).to eq(3.times.to_a)
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

    describe "#recursive_round!" do
      it "plays as normal for the first 8 rounds" do
        8.times { ad.recursive_round! }
        expect(ad.decks.first).to eq([4, 9, 8, 5, 2])
        expect(ad.decks.last).to eq([3, 10, 1, 7, 6])
      end

      it "plays a sub-game to determine the winner of round 9" do
        9.times { ad.recursive_round! }
        expect(ad.decks.first).to eq([9, 8, 5, 2])
        expect(ad.decks.last).to eq([10, 1, 7, 6, 3, 4])
      end

      # Handled by above case implicitly
      xit "orders the resulting cards correctly (sometimes the winning card is lower)"
      xit "doesn't play a sub-game if one player doesn't have enough cards"

      it "makes player 1 the winner if there was a previous round in this game that had exactly the same cards in the same order" do
        input = <<~EOS
        Player 1:
        43
        19

        Player 2:
        2
        29
        14
        EOS
        ad = Advent::Crab.new(input)
        expect(ad.decks.first.count).to eq(2)
        ad.recursive_combat!
        expect(ad.score).to eq(273)
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

      it "calculates teh correct score for recursive combat" do
        ad.recursive_combat!
        expect(ad.score).to eq(291)
      end
    end

    context "validation" do
    end
  end
end
