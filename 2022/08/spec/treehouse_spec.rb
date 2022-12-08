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

    describe "#viewing_distance" do
      context "middle in second row [2,1]" do
        let(:cell) { [2,1] }

        it "Looking up, its view is not blocked; it can see 1 tree (of height 3)." do
          expect(ad.viewing_distance(cell, [0,-1])).to eq(1)
        end

        it "Looking left, its view is blocked immediately; it can see only 1 tree (of height 5, right next to it)." do
          expect(ad.viewing_distance(cell, [-1,0])).to eq(1)
        end

        it "Looking right, its view is not blocked; it can see 2 trees." do
          expect(ad.viewing_distance(cell, [1,0])).to eq(2)
        end

        it "Looking down, its view is blocked eventually; it can see 2 trees (one of height 3, then the tree of height 5 that blocks its view)." do
          expect(ad.viewing_distance(cell, [0,1])).to eq(2)
        end
      end
    end

    describe "#scenic_score" do
      {
        [0,0] => 0,
        [2,1] => 4,
        [2,3] => 8,
        [0,2] => 0,
      }.each do |cell, score|
        it "returns the score #{score} for cell #{cell}" do
          expect(ad.scenic_score(cell)).to eq(score)
        end
      end
    end

    describe "#max_scenic_score" do
      it "returns the max scenic score" do
        expect(ad.max_scenic_score).to eq(8)
      end
    end
  end
end
