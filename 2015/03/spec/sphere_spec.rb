require './sphere.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    ^>v<
    EOS
  }

  describe Advent::Sphere do
    let(:ad) { Advent::Sphere.new(input) }

    describe "#new" do
      it "loads directions" do
        expect(ad.directions).to eq(['^','>','v','<'])
      end
      it "inits an empty grid" do
        expect(ad.grid.cells).to eq({})
      end
    end

    describe "#trace!" do
      it "visits cells in the grid" do
        ad.trace!
        expect(ad.grid.cells).to eq({
          [0,0] => 2,
          [0,-1] => 1,
          [1,-1] => 1,
          [1,0] => 1,
        })
      end
    end

    describe "#robo_trace!" do
      it "creates two grids" do
        ad.robo_trace!
        expect(ad.grid.cells).to eq({
          [0,0] => 2,
          [0,-1] => 1,
        })
        expect(ad.robo_grid.cells).to eq({
          [0,0] => 2,
          [1,0] => 1,
        })
      end
    end

    # Misread problem and this method isn't actually necessary
    describe "#dupes" do
      it "returns the coordinates of the houses visited twice" do
        ad.trace!
        expect(ad.dupes).to eq([[0,0]])
      end
    end

    context "validation" do
      {
        '^v' => 3,
        '^>v<' => 3,
        '^v^v^v^v^v' => 11,
      }.each do |inp, expected|
        it "returns #{expected} houses visited for #{inp}" do
          ad = Advent::Sphere.new(inp)
          expect(ad.robo_houses).to eq(expected)
        end
      end
    end
  end
end
