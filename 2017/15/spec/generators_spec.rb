require './generators.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    Generator A starts with 65
    Generator B starts with 8921
    EOS
  }

  describe Advent::Generators do
    let(:ad) { Advent::Generators.new(input) }

    describe "#new" do
      it "inits seed values" do
        expect(ad.generators).to eq([65, 8921])
      end
    end

    describe "#generate" do
      it "generates values for each generator" do
        vals = ad.generate!
        expect(vals).to eq([1092455, 430625591])
      end

      it "stores them in the generators var" do
        ad.generate!
        expect(ad.generators).to eq([1092455, 430625591])
      end

      it "produces the correct sequence" do
        expect(ad.generate!).to eq([1092455, 430625591])
        expect(ad.generate!).to eq([1181022009, 1233683848])
        expect(ad.generate!).to eq([245556042, 1431495498])
        expect(ad.generate!).to eq([1744312007, 137874439])
        expect(ad.generate!).to eq([1352636452, 285222916])
      end
    end

    describe "match?" do
      it "returns false if the first 16 bits don't match" do
        expect(ad.match?).to be_falsey
      end

      it "returns true if the first 16 bits do match" do
        3.times { ad.generate! }
        expect(ad.match?).to be_truthy
      end
    end

    describe "#sample" do
      it "returns the number of matching pairs in a given sample" do
        expect(ad.sample(5)).to eq(1)
      end

      xit "returns the number of matching pairs in a very large sample" do
        expect(ad.sample(40_000_000)).to eq(588)
      end
    end

    context "validation" do
    end
  end
end
