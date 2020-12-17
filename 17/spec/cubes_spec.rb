require '../cubes.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      .#.
      ..#
      ###
    EOS
  }

  describe Advent::Cubes do
    let(:ad) { Advent::Cubes.new(input) }

    describe "#new" do
      it "inits a grid based on input" do
        expect(ad.grid).to eq(Set.new([
          [1,0,0],
          [2,1,0],
          [0,2,0],
          [1,2,0],
          [2,2,0],
        ]))
      end

      it "sets cycle to 0" do
        expect(ad.cycle).to eq(0)
      end

      it "inits a 4D grid based on input" do
        ad = Advent::Cubes.new(input, 4)
        expect(ad.grid).to eq(Set.new([
          [1,0,0,0],
          [2,1,0,0],
          [0,2,0,0],
          [1,2,0,0],
          [2,2,0,0],
        ]))
      end
    end

    describe "#neighbor_coords" do
      it "returns 26 coords" do
        expect(ad.neighbor_coords([0,0,0]).count).to eq(26)
      end

      it "returns 80 coords in a 4D space" do
        ad = Advent::Cubes.new(input, 4)
        expect(ad.neighbor_coords([0,0,0,0]).count).to eq(80)
      end
    end

    describe "#neighbors" do
      it "returns empty neighbor coordinates" do
        expect(ad.neighbors([10,10,10])).to be_empty
      end

      it "returns active neighbors" do
        expect(ad.neighbors([1,0,0])).to contain_exactly([2,1,0])
      end
    end

    describe "#cycle!" do
      it "increments the cycle" do
        expect { ad.cycle! }.to change{ ad.cycle }.by(1)
      end
      it "runs a cycle assuming If a cube is active and exactly 2 of its neighbors are also active, the cube remains active." do
        ad.cycle!
        expect(ad.grid).to include([2,2,0])
      end

      it "runs a cycle assuming If a cube is active and exactly 3 of its neighbors are also active, the cube remains active." do
        ad.cycle!
        expect(ad.grid).to include([2,1,0])
      end

      it "runs a cycle assuming If a cube is active and exactly 1 of its neighbors are also active, the cube turns inactive." do
        ad.cycle!
        expect(ad.grid).to_not include([1,0,0])
      end

      # The sample input doesn't use the same coordinate system!!!
      it "runs a cycle assuming If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active." do
        ad.cycle!
        expect(ad.grid).to include([0,1,-1])
      end
    end

    context "validation" do
      it "sets 112 active cubes after 6 cycles according to part 1 problem" do
        6.times { ad.cycle! }
        expect(ad.grid.count).to eq(112)
      end

      it "sets 848 active cubes after 6 cycles according to part 2 problem when using a 4D grid" do
        ad = Advent::Cubes.new(input, 4)
        6.times { ad.cycle! }
        expect(ad.grid.count).to eq(848)
      end
    end
  end
end
