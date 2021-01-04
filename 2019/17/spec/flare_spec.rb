require './flare.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) { File.read('./spec_input.txt') }

  describe Advent::Flare do
    let(:ad) { Advent::Flare.new(input) }

    describe "#new" do
      it "inits an intcode program" do
        expect(ad.program).to be_a(Advent::IntCode)
      end

      it "inits an empty grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid.cells).to be_empty
      end
    end

    describe "#fill_grid!" do
      it "fills a grid using the intcode program output" do
        ad.fill_grid!
        expect(ad.grid.cells).to_not be_empty
        expect(ad.grid.width).to eq(47)
        expect(ad.grid.cells).to include(
          [ 0, 0] => '.',
          [46, 0] => '.',
          [ 0,38] => '.',
          [46,38] => '.',
          [10, 4] => '#',
          [ 6,14] => '^',
        )
      end
    end

    describe "#intersections" do
      before do
        ad.fill_grid!
      end

      it "finds coordinates where cardinal directions and self are '#' symbols" do
        expect(ad.intersections).to include(
          [16, 6],
          [16, 8],
        )
      end
    end

    context "validation" do
    end
  end
end
