require './rps.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
A Y
B X
C Z
    EOS
  }

  describe Advent::Rps do
    let(:ad) { Advent::Rps.new(input) }

    describe "#new" do
      it "loads the input" do
        expect(ad.rounds[0]).to eq(['A', 'Y'])
        expect(ad.rounds[1]).to eq(['B', 'X'])
        expect(ad.rounds[2]).to eq(['C', 'Z'])
      end
    end

    describe "#play_round" do
      describe "returns a score for your selection" do
        [
          ["1 for Rock", 1, 'X'],
          ["2 for Paper", 2, 'Y'],
          ["3 for Scissors", 3, 'Z'],
        ].each do |test_name, expected, selection|
          it test_name do
            expect(ad.play_round(['A', selection])[0]).to eq(expected)
          end
        end
      end

      describe "returns a score your round" do
        [
          ["0 if you lost", 0, 'B', 'X'],
          ["3 if the round was a draw", 3, 'A', 'X'],
          ["6 if you won", 6, 'C', 'X'],
        ].each do |test_name, expected, opponent, selection|
          it test_name do
            expect(ad.play_round([opponent, selection])[1]).to eq(expected)
          end
        end
      end
    end

    describe "#score_round" do
      it "In the first round, your opponent will choose Rock (A), and you should choose Paper (Y). This ends in a win for you with a score of 8 (2 because you chose Paper + 6 because you won)." do
        expect(ad.score_round(ad.rounds[0])).to eq(8)
      end

      it "In the second round, your opponent will choose Paper (B), and you should choose Rock (X). This ends in a loss for you with a score of 1 (1 + 0)." do
        expect(ad.score_round(ad.rounds[1])).to eq(1)
      end

      it "The third round is a draw with both players choosing Scissors, giving you a score of 3 + 3 = 6." do
        expect(ad.score_round(ad.rounds[2])).to eq(6)
      end
    end

    describe "#score_round_2" do
      it "In the first round, your opponent will choose Rock (A), and you need the round to end in a draw (Y), so you also choose Rock. This gives you a score of 1 + 3 = 4." do
        expect(ad.score_round_2(ad.rounds[0])).to eq(4)
      end

      it "In the second round, your opponent will choose Paper (B), and you choose Rock so you lose (X) with a score of 1 + 0 = 1." do
        expect(ad.score_round_2(ad.rounds[1])).to eq(1)
      end

      it "In the third round, you will defeat your opponent's Scissors with Rock for a score of 1 + 6 = 7." do
        expect(ad.score_round_2(ad.rounds[2])).to eq(7)
      end
    end

    describe "#play" do
      it "In this example, if you were to follow the strategy guide, you would get a total score of 15 (8 + 1 + 6)." do
        expect(ad.play).to eq(15)
      end
    end

    describe "#play" do
      it "Now that you're correctly decrypting the ultra top secret strategy guide, you would get a total score of 12." do
        expect(ad.play_2).to eq(12)
      end
    end

    context "validation" do
    end
  end
end
