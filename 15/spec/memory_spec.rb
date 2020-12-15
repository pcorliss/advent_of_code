require '../memory.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {"0,3,6"}

  describe Advent::Memory do
    let(:ad) { Advent::Memory.new(input) }

    describe "#new" do
      it "inits a new hash" do
        expect(ad.first).to eq({
          0 => 1,
          3 => 2,
          6 => 3,
        })
        expect(ad.last).to eq({
          0 => 1,
          3 => 2,
          6 => 3,
        })
      end

      it "sets the turn number to n" do
        expect(ad.turn).to eq(3)
      end
    end

    describe "#goto_turn!" do
      it "advances the turn 1 step" do
        ad.goto_turn!(4)
        expect(ad.turn).to eq(4)
      end

      it "updates the last hash but not the first" do
        ad.goto_turn!(4)
        expect(ad.last[0]).to eq(4)
        expect(ad.first[0]).to eq(1)
      end

      it "returns the num spoken" do
        expect(ad.goto_turn!(4)).to eq(0)
      end

      it "handles diffs" do
        expect(ad.goto_turn!(5)).to eq(3)
      end

      it "handles multi diffs" do
        expect(ad.goto_turn!(6)).to eq(3)
        expect(ad.goto_turn!(7)).to eq(1)
      end

      it "handles new nums" do
        expect(ad.goto_turn!(8)).to eq(0)
        expect(ad.goto_turn!(9)).to eq(4)
        expect(ad.goto_turn!(10)).to eq(0)
      end
    end

    context "validation" do
      {
        "0,3,6" => 436,
        "1,3,2" => 1,
        "2,1,3" => 10,
        "1,2,3" => 27,
        "2,3,1" => 78,
        "3,2,1" => 438,
        "3,1,2" => 1836,
      }.each do |input, expected|
        it "expects #{expected} when #{input} input is received for the 2020th iteration" do
          ad = Advent::Memory.new(input)
          expect(ad.goto_turn!(2020)).to eq(expected)
        end
      end
    end
  end
end
