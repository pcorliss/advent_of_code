require './wrapping.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    2x3x4
    1x1x10
    EOS
  }

  describe Advent::Wrapping do
    let(:ad) { Advent::Wrapping.new(input) }

    describe "#new" do
      it "inits presents" do
        expect(ad.presents.count).to eq(2)
        expect(ad.presents.first).to eq([2,3,4])
      end
    end

    describe "#paper" do
      it "returns the paper required for a set of dimensions" do
        expect(ad.paper([2,3,4])).to eq(58)
      end

      it "returns the paper required for a set of dimensions" do
        expect(ad.paper([1,1,10])).to eq(43)
      end
    end

    context "validation" do
      it "returns the total paper requirements" do
        expect(ad.total_paper).to eq(101)
      end
    end
  end
end
