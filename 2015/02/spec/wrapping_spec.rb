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

    describe "#ribbon" do
      {
        [2,3,4] => 10,
        [1,1,10] => 4,
      }.each do |dims, expected|
        it "returns #{expected} for dimensions #{dims}" do
          expect(ad.ribbon(dims)).to eq(expected)
        end
      end
    end

    describe "#bow" do
      {
        [2,3,4] => 24,
        [1,1,10] => 10,
      }.each do |dims, expected|
        it "returns #{expected} for dimensions #{dims}" do
          expect(ad.bow(dims)).to eq(expected)
        end
      end
    end

    context "validation" do
      it "returns the total paper requirements" do
        expect(ad.total_paper).to eq(101)
      end

      it "returns the total ribbon requirements" do
        expect(ad.total_ribbon).to eq(48)
      end
    end
  end
end
