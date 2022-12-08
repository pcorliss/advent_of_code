require './treehouse.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
30373
25512
65332
33549
35390
    EOS
  }

  describe Advent::Treehouse do
    let(:ad) { Advent::Treehouse.new(input) }

    describe "#new" do
      it "instantiates a grid" do
        expect(ad.grid.width).to eq(5)
        expect(ad.grid.height).to eq(5)
        expect(ad.grid.cells).to include({
          [0,0] => '3',
          [4,0] => '3',
          [0,4] => '3',
          [4,4] => '0',
        })
      end
    end

    describe "#visible" do
      [
        [0,0],
        [2,0],
        [4,0],
        [0,4],
        [0,2],
        [2,4],
        [4,2],
        [4,4],
      ].each do |cell|
        it "returns true if a cell is on the edge #{cell}" do
          expect(ad.visible(cell)).to be_truthy
        end
      end

      {
        # The top-left 5 is visible from the left and top. (It isn't visible from the right or bottom since other trees of height 5 are in the way.)
        [1,1] => true,
        # The top-middle 5 is visible from the top and right.
        [2,1] => true,
        # The top-right 1 is not visible from any direction; for it to be visible, there would need to only be trees of height 0 between it and an edge.
        [3,1] => false,
        # The left-middle 5 is visible, but only from the right.
        [1,2] => true,
        # The center 3 is not visible from any direction; for it to be visible, there would need to be only trees of at most height 2 between it and an edge.
        [2,2] => false,
        # The right-middle 3 is visible from the right.
        [3,2] => true,
        # In the bottom row, the middle 5 is visible, but the 3 and 4 are not.
        [1,3] => false,
        [2,3] => true,
        [3,3] => false,
      }.each do |cell, expected|
        it "returns #{expected} for cell #{cell}" do
          expect(ad.visible(cell)).to eq(expected)
        end
      end
    end

    describe "#count_visible" do
      it "counts all visible cells" do
        expect(ad.count_visible).to eq(21)
      end
    end
  end
end
