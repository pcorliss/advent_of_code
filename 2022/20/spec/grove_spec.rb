require './grove.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
1
2
-3
3
-2
0
4
    EOS
  }

  describe Advent::Grove do
    let(:ad) { Advent::Grove.new(input) }

    describe "#new" do
      it "inits the ring" do
        expect(ad.ring.to_a).to eq([1, 2, -3, 3, -2, 0, 4])
      end
    end

    describe "#mix" do
      it "mixes the ring" do
        expect(ad.mix.to_a).to eq([1, 2, -3, 4, 0, 3, -2])
      end
    end

    describe "#coords" do
      # Then, the grove coordinates can be found by looking at the 1000th, 2000th, and 3000th numbers after the value 0,
      # wrapping around the list as necessary.
      # In the above example, the 1000th number after 0 is 4, the 2000th is -3, and the 3000th is 2;
      # adding these together produces 3.

      it "returns the 1000, 2000th, and 3000th digit starting at 0" do
        ad.mix
        expect(ad.coords).to eq([4, -3, 2])
      end
    end

    context "validation" do
    end
  end
end
