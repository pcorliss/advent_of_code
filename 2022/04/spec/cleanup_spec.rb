require './cleanup.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
    EOS
  }

  describe Advent::Cleanup do
    let(:ad) { Advent::Cleanup.new(input) }

    describe "#new" do
      it "loads ranges" do
        expect(ad.ranges.count).to eq(6)
        expect(ad.ranges.first.first).to eq(2..4)
        expect(ad.ranges.first.last).to eq(6..8)
      end
    end

    describe "cover?" do
      it "returns false if there's no cover" do
        expect(ad.cover?(ad.ranges.first)).to be_falsey
      end

      it "returns false if there's cover by the first range" do
        expect(ad.cover?(ad.ranges[3])).to be_truthy
      end

      it "returns false if there's cover by the second range" do
        expect(ad.cover?(ad.ranges[4])).to be_truthy
      end
    end

    describe "count_cover" do
      it "returns the number of pairs with a complete cover" do
        expect(ad.count_cover).to eq(2)
      end
    end

    describe "overlap?" do
      it "returns false if there's no overlap" do
        expect(ad.overlap?(ad.ranges.first)).to be_falsey
      end

      it "returns false if there's overlap by the first range" do
        expect(ad.overlap?(ad.ranges[2])).to be_truthy
      end

      it "returns false if there's overlap by the second range" do
        expect(ad.overlap?(ad.ranges[4])).to be_truthy
      end
    end

    describe "count_overlap" do
      it "returns the number of pairs with a complete overlap" do
        expect(ad.count_overlap).to eq(4)
      end
    end

    context "validation" do
    end
  end
end
