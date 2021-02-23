require './hvac.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
    EOS
  }

  describe Advent::Hvac do
    let(:ad) { Advent::Hvac.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid[1,1]).to eq('0')
      end
    end


    describe "#starting" do
      it "returns the grid point of the starting location '0'" do
        expect(ad.starting).to eq([1,1])
      end
    end

    describe "#locations" do
      it "returns a hash of the keys and their locations" do
        expect(ad.locations).to include(
          [1,1] => '0',
          [3,1] => '1',
        )
      end
    end

    describe "#map" do
      it "maps key-to-key distances from starting point" do
        # ad.debug!
        expect(ad.map['0']).to eq({
          '1' => 2,
          '4' => 2,
          '3' => 10,
          '2' => 8,
        })
      end

      it "maps non-starting point distances" do
        ad.debug!
        expect(ad.map['3']).to eq({
          '1' => 8,
          '4' => 8,
          '0' => 10,
          '2' => 2,
        })
      end
    end

    context "validation" do
    end
  end
end
