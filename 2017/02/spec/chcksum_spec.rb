require './chcksum.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
5	1	9	5
7	5	3
2	4	6	8
    EOS
  }

  describe Advent::Chcksum do
    let(:ad) { Advent::Chcksum.new(input) }

    describe "#new" do
      it "inits a list of lists of integers" do
        expect(ad.sheet.count).to eq(3)
        expect(ad.sheet.first).to eq([5,1,9,5])
      end
    end

    describe "#min_max_diff" do
      it "yields the sum of the min and max" do
        expect(ad.min_max_diff([5,1,9,5])).to eq(8)
      end
    end

    describe "#checksum" do
      it "yields the sum of the individual checksums" do
        expect(ad.checksum).to eq(18)
      end
    end

    context "validation" do
    end
  end
end
