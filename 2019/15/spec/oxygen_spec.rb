require './oxygen.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) { File.read('./spec_input.txt') }

  describe Advent::Oxygen do
    let(:ad) { Advent::Oxygen.new(input) }

    describe "#new" do
      it "instantiates the program" do
        expect(ad.program).to be_a(Advent::IntCode)
      end

      it "instantiates the grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid.cells[[0,0]]).to eq(' ')
      end
    end

    describe "#move!" do
      it "creates multiple possible paths" do
        ad.move!
        expect(ad.paths.count).to be >= 1
      end

      # This is dependant on input.txt (mine) being present
      it "updates the grid with walls and open spaces" do
        ad.move!
        expect(ad.grid.cells).to eq({
          [ 0, 0] => ' ',
          [ 0, 1] => ' ',
          [ 1, 0] => '#',
          [-1, 0] => '#',
          [ 0,-1] => '#',
        })
      end

      it "prunes paths which hit walls" do
        ad.move!
        expect(ad.paths.count).to eq(1)
      end

      it "prunes paths which travel ground already traveled" do
        ad.move!
        ad.move!
        expect(ad.paths.count).to eq(1)
      end

      it "paths register the oxygen sensor once it's found" do
        400.times { ad.move! }
        expect(ad.sensor).to eq([-20, 12])
        expect(ad.sensor_found_in).to eq(380)
      end
    end

    context "validation" do
    end
  end
end
