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

      it "sets a multiplier" do
        expect(ad.mult).to eq(1)
      end

      it "sets an optional multiplier" do
        ad = Advent::Grove.new(input, 811589153)
        expect(ad.mult).to eq(811589153)
        expect(ad.ring.to_a).to eq([811589153, 1623178306, -2434767459, 2434767459, -1623178306, 0, 3246356612])
      end
    end

    describe "#mix" do
      it "mixes the ring" do
        # ad.debug!
        expect(ad.mix.to_a).to eq([1, 2, -3, 4, 0, 3, -2])
      end

      context "multiplier" do
        let(:ad) { Advent::Grove.new(input, 811589153) }
        let(:zero) { ad.ring.nodes.find { |n| n.val.zero? } }

        it "mixes with a multiplier" do
          # ad.debug!
          expect(ad.mix.to_a(zero)).to eq([0, -2434767459, 3246356612, -1623178306, 2434767459, 1623178306, 811589153])
        end

        it "maintains the order in multiple rounds of mixing" do
          # 2.times { ad.mix }
          # expect(ad.ring.to_a(zero)).to eq([0, 2434767459, 1623178306, 3246356612, -2434767459, -1623178306, 811589153])
          10.times { ad.mix }
          expect(ad.ring.to_a(zero)).to eq([0, -2434767459, 1623178306, 3246356612, -1623178306, 2434767459, 811589153])
        end
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

      context "multiplier" do
        let(:ad) { Advent::Grove.new(input, 811589153) }

        it "returns the 1000, 2000th, and 3000th digit starting at 0" do
          10.times { ad.mix }
          expect(ad.coords).to eq([811589153, 2434767459, -1623178306])
          expect(ad.coords.sum).to eq(1623178306)
        end
      end
    end

    context "validation" do
      let(:input) { File.read('./input.txt') }

      it "returns the 1000, 2000th, and 3000th digit starting at 0" do
        ad.mix
        expect(ad.coords.sum).to eq(7153)
      end
    end
  end
end
