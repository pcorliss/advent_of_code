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

    describe "#evenly_div" do
      {
        [5,9,2,8,] => 4,
        [9,4,7,3,] => 3,
        [3,8,6,5,] => 2,
      }.each do |digits, expected|
        it "returns the result of dividing the only two integers that are evenly divisible #{digits} => #{expected}" do 
          expect(ad.evenly_div(digits)).to eq(expected)
        end
      end
    end

    context "validation" do
      let(:input) {
        <<~EOS
        5 9 2 8
        9 4 7 3
        3 8 6 5
        EOS
      }

      describe "#checksum_div" do
        it "yields the expected checksum" do
          expect(ad.checksum_div).to eq(9)
        end
      end
    end
  end
end
