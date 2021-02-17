require './tiles.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    ..^^.
    EOS
  }

  describe Advent::Tiles do
    let(:ad) { Advent::Tiles.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid.cells).to eq(
          [0,0] => '.',
          [1,0] => '.',
          [2,0] => '^',
          [3,0] => '^',
          [4,0] => '.',
        )
      end
    end

    describe "#trap?" do
      it "returns true if the tile is a trap" do
        expect(ad.trap?([2,0])).to be_truthy
      end

      it "returns false if the tile is safe" do
        expect(ad.trap?([0,0])).to be_falsey
      end

      context "is a trap" do
        it "Its left and center tiles are traps, but its right tile is not." do
          ad = Advent::Tiles.new("^^.")
          expect(ad.trap?([1,1])).to be_truthy
        end

        it "Its center and right tiles are traps, but its left tile is not." do
          ad = Advent::Tiles.new(".^^")
          expect(ad.trap?([1,1])).to be_truthy
        end

        it "Only its left tile is a trap." do
          ad = Advent::Tiles.new("^..")
          expect(ad.trap?([1,1])).to be_truthy
        end

        it "Only its right tile is a trap." do
          ad = Advent::Tiles.new("..^")
          expect(ad.trap?([1,1])).to be_truthy
        end
      end

      context "is not a trap" do
        it "center tile is a trap" do
          ad = Advent::Tiles.new(".^.")
          expect(ad.trap?([1,1])).to be_falsey
        end

        it "left and right tile is a trap" do
          ad = Advent::Tiles.new("^.^")
          expect(ad.trap?([1,1])).to be_falsey
        end

        it "none are traps" do
          ad = Advent::Tiles.new("...")
          expect(ad.trap?([1,1])).to be_falsey
        end

        it "all are traps" do
          ad = Advent::Tiles.new("^^^")
          expect(ad.trap?([1,1])).to be_falsey
        end
      end

      it "returns false if the x is out of bounds" do
          expect(ad.trap?([-1,0])).to be_falsey
          expect(ad.trap?([5,0])).to be_falsey
      end

      it "returns false if the y is out of bounds" do
          expect(ad.trap?([0,-1])).to be_falsey
      end

      it "considers missing tiles to be safe" do
        ad = Advent::Tiles.new("^^")
        expect(ad.trap?([1,1])).to be_truthy
      end

      it "caches the lookup result" do
        ad.trap?([1,1])
        expect(ad.grid[1,1]).to eq('^')
      end

      it "recursively looks up tiles" do
        expect(ad.trap?([2,2])).to be_falsey
      end
    end

    context "validation" do
      it "yields a proper rendering of a 5x3 grid" do
        expected = <<~EOS
        ..^^.
        .^^^^
        ^^..^
        EOS
        ad.fill_rows!(3)
        expect(ad.grid.render).to eq(expected.chomp)
      end

      it "yields a proper rendering of a 10x10 grid" do
        ad = Advent::Tiles.new(".^^.^.^^^^")
        expected = <<~EOS
.^^.^.^^^^
^^^...^..^
^.^^.^.^^.
..^^...^^^
.^^^^.^^.^
^^..^.^^..
^^^^..^^^.
^..^^^^.^^
.^^^..^.^^
^^.^^^..^^
        EOS
        ad.fill_rows!(10)
        expect(ad.grid.render).to eq(expected.chomp)
        expect(ad.safe_tiles).to eq(38)
      end
    end
  end
end
