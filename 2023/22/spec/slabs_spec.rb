require './slabs.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    1,0,1~1,2,1
    0,0,2~2,0,2
    0,2,3~2,2,3
    0,0,4~0,2,4
    2,0,5~2,2,5
    0,1,6~2,1,6
    1,1,8~1,1,9
    EOS
  }

  describe Advent::Slabs do
    let(:ad) { Advent::Slabs.new(input) }

    describe "#new" do
      it "inits a list of 3D bricks" do
        expect(ad.bricks.count).to eq(7)
        expect(ad.bricks.first.map(&:to_a)).to eq([[1,0,1],[1,2,1]])
        expect(ad.bricks.last.map(&:to_a)).to eq([[1,1,8],[1,1,9]])
      end
    end

    describe "#brick_intersects?" do
      it "returns false if two bricks don't intersect" do
        ad.bricks.combination(2).each do |a,b|
          expect(ad.brick_intersects?(a,b)).to be_falsey
        end
      end

      it "returns true if two bricks intersect on the x axis" do
        a = [Advent::Slabs::Point.new(1,1,1), Advent::Slabs::Point.new(3,1,1)]
        b = [Advent::Slabs::Point.new(0,1,1), Advent::Slabs::Point.new(2,1,1)]
        expect(ad.brick_intersects?(a,b)).to be_truthy
      end

      it "returns true if two bricks intersect on the y axis" do
        a = [Advent::Slabs::Point.new(1,1,1), Advent::Slabs::Point.new(1,3,1)]
        b = [Advent::Slabs::Point.new(1,0,1), Advent::Slabs::Point.new(1,2,1)]
        expect(ad.brick_intersects?(a,b)).to be_truthy
      end

      it "returns true if two bricks intersect on the z axis" do
        a = [Advent::Slabs::Point.new(1,1,1), Advent::Slabs::Point.new(1,1,3)]
        b = [Advent::Slabs::Point.new(1,1,0), Advent::Slabs::Point.new(1,1,2)]
        expect(ad.brick_intersects?(a,b)).to be_truthy
      end
    end

    describe "#drop_bricks!" do
      it "drops bricks until they can't drop anymore" do
        ad.drop_bricks!
        expect(ad.bricks.count).to eq(7)
        # 1,0,1~1,2,1   <- A
        expect(ad.bricks[0].map(&:to_a)).to eq([[1,0,1],[1,2,1]])
        # 0,0,2~2,0,2   <- B
        expect(ad.bricks[1].map(&:to_a)).to eq([[0,0,2],[2,0,2]])
        # 0,2,2~2,2,2   <- C
        expect(ad.bricks[2].map(&:to_a)).to eq([[0,2,2],[2,2,2]])
        # 0,0,3~0,2,3   <- D
        expect(ad.bricks[3].map(&:to_a)).to eq([[0,0,3],[0,2,3]])
        # 2,0,3~2,2,3   <- E
        expect(ad.bricks[4].map(&:to_a)).to eq([[2,0,3],[2,2,3]])
        # 0,1,4~2,1,4   <- F
        expect(ad.bricks[5].map(&:to_a)).to eq([[0,1,4],[2,1,4]])
        # 1,1,5~1,1,6   <- G
        expect(ad.bricks[6].map(&:to_a)).to eq([[1,1,5],[1,1,6]])
      end
    end

# Brick A cannot be disintegrated safely; if it were disintegrated, bricks B and C would both fall.
# Brick B can be disintegrated; the bricks above it (D and E) would still be supported by brick C.
# Brick C can be disintegrated; the bricks above it (D and E) would still be supported by brick B.
# Brick D can be disintegrated; the brick above it (F) would still be supported by brick E.
# Brick E can be disintegrated; the brick above it (F) would still be supported by brick D.
# Brick F cannot be disintegrated; the brick above it (G) would fall.
# Brick G can be disintegrated; it does not support any other bricks.

    describe "#disintegratable_bricks" do
      it "returns a list of bricks that aren't solely load bearing" do
        ad.drop_bricks!
        # ad.debug!
        bricks = ad.disintegratable_bricks
        # puts "Disintegratable Bricks: #{bricks.map(&:to_a).inspect}"
        expect(bricks.count).to eq(5)
        expect(bricks).to include(ad.bricks[1])
        expect(bricks).to include(ad.bricks[2])
        expect(bricks).to include(ad.bricks[3])
        expect(bricks).to include(ad.bricks[4])
        expect(bricks).to include(ad.bricks[6])
      end
    end

    describe "#brick_fall_count" do
      before do
        ad.drop_bricks!
      end

      [6,0,0,0,0,1,0].each_with_index do |expected, idx|
        it "returns the number of bricks that would fall if a brick was removed" do
          # ad.debug!
          expect(ad.brick_fall_count([ad.bricks[idx]])).to eq(expected)
        end
      end
    end

    describe "#brick_fall_sum" do
      before do
        ad.drop_bricks!
      end

      it "returns the number of bricks that would fall if a brick was removed" do
        expect(ad.brick_fall_sum).to eq(7)
      end
    end

    context "validation" do
      let(:input) { File.read('./input.txt') }

      it "solves part1" do
        ad.drop_bricks!
        expect(ad.disintegratable_bricks.count).to eq(473)
      end
    end
  end
end
