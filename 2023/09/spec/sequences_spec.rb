require './sequences.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
    EOS
  }

  describe Advent::Sequences do
    let(:ad) { Advent::Sequences.new(input) }

    describe "#new" do
      it "inits sequences" do
        expect(ad.sequences).to eq([
          [0, 3, 6, 9, 12, 15],
          [1, 3, 6, 10, 15, 21],
          [10, 13, 16, 21, 30, 45],
        ])
      end
    end

    describe "#next_number" do
      it "returns the next number in the sequence" do
        # ad.debug!
        expect(ad.next_number([0, 3, 6, 9, 12, 15])).to eq(18)
        expect(ad.next_number([1, 3, 6, 10, 15, 21])).to eq(28)
        expect(ad.next_number([10, 13, 16, 21, 30, 45])).to eq(68)
      end
    end

    describe "#prev_number" do
      it "returns the next number in the sequence" do
        # ad.debug!
        expect(ad.prev_number([0, 3, 6, 9, 12, 15])).to eq(-3)
        expect(ad.prev_number([1, 3, 6, 10, 15, 21])).to eq(0)
        expect(ad.prev_number([10, 13, 16, 21, 30, 45])).to eq(5)
      end
    end

    context "validation" do
      it "returns the sum of the next number in the sequence for part 1" do
        expect(ad.sum_next_number).to eq(114)
      end

      it "returns the sum of the prev number in the sequence for part 2" do
        expect(ad.sum_prev_number).to eq(2)
      end
    end
  end
end
