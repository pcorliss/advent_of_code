require './discs.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    Disc #1 has 5 positions; at time=0, it is at position 4.
    Disc #2 has 2 positions; at time=0, it is at position 1.
    EOS
  }

  describe Advent::Discs do
    let(:ad) { Advent::Discs.new(input) }

    describe "#new" do
      it "inits a list of discs" do
        expect(ad.discs.count).to eq(2)
        expect(ad.discs[0]).to eq([1, 5, 4])
        expect(ad.discs[1]).to eq([2, 2, 1])
      end
    end

    describe "#find_common" do
      it "finds the common zero point for all discs" do
        expect(ad.find_common).to eq(5)
      end
    end

    context "validation" do
    end
  end
end
