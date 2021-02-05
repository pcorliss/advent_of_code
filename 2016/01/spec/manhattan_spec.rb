require './manhattan.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    R5, L5, R5, R3
    EOS
  }

  describe Advent::Manhattan do
    let(:ad) { Advent::Manhattan.new(input) }

    describe "#new" do
      it "inits a list of instructions" do
        expect(ad.inst).to eq([
          ["R", 5],
          ["L", 5],
          ["R", 5],
          ["R", 3],
        ])
      end

      it "handles multi-char distances" do
        ad = Advent::Manhattan.new("R190")
        expect(ad.inst).to eq([['R',190]])
      end

      it "inits a position" do
        expect(ad.pos).to eq([0,0])
      end

      it "inits a direction" do
        expect(ad.direction).to eq(0)
      end
    end

    describe "#walk!" do
      it "reads the directions and sends you to the proper coords" do
        ad.walk!
        expect(ad.pos).to eq([10,2])
        expect(ad.direction).to eq(180)
      end

      it "bails if we've already visited this spot before" do
        ad = Advent::Manhattan.new("R3, L1, L1, L3")
        ad.walk!(true)
        expect(ad.pos).to eq([2, 0])
      end
    end

    describe "#distance" do
      it "returns the manhattan distance of a given position" do
        expect(ad.distance).to eq(0)
        ad.walk!
        expect(ad.distance).to eq(12)
      end
    end

    context "validation" do
    end
  end
end
