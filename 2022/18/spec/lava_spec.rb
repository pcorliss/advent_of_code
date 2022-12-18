require './lava.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
    EOS
  }

  describe Advent::Lava do
    let(:ad) { Advent::Lava.new(input) }

    describe "#new" do
      it "inits a list of cubes" do
        expect(ad.cubes.count).to eq(13)
        expect(ad.cubes.first).to eq([2,2,2])
      end
    end

    describe "exposed_sides" do
      let(:simple) {
        <<~EOS
        1,1,1
        2,1,1
        EOS
      }
      it "returns the number of sides exposed" do
        ad = Advent::Lava.new(simple)
        expect(ad.exposed_sides).to eq(10)
      end

      let(:simple2) {
        <<~EOS
        2,2,2
        1,2,2
        3,2,2
        EOS
      }

      it "returns the number of sides exposed for a 3 cube example" do
        ad = Advent::Lava.new(simple2)
        expect(ad.exposed_sides).to eq(14)
      end

      it "returns the number of sides exposed for a larger example" do
        expect(ad.exposed_sides).to eq(64)
      end
    end

    context "validation" do
    end
  end
end
