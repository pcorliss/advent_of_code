require '../jigsaw.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
    EOS
  }

  describe Advent::Jigsaw do
    let(:ad) { Advent::Jigsaw.new(input) }

    describe "#new" do
      it "loads a collection of tiles" do
        expect(ad.tiles.count).to eq(9)
        expect(ad.tiles.first).to be_a(Advent::Tile)
      end
    end

    describe "#corners" do
      it "finds tiles with only two matching edges" do
        expect(ad.corners.map(&:id)).to contain_exactly(1951 , 3079 , 2971 , 1171)
      end
    end

    context "validation" do
    end
  end

  describe Advent::Tile do
    let(:input) {
      <<~EOS
      Tile 2311:
      ..#
      ###
      #.#
      EOS
    }
    let(:tile) { Advent::Tile.new(input) }
    describe "#new" do
      it "sets the tile id" do
        expect(tile.id).to eq(2311)
      end
    end

    describe "#edges" do
      it "computes the edge ids for four sides" do
        # ..#
        expect(tile.edges).to contain_exactly(1, 7, 5, 3)
      end
      #
      # it "uses the smaller edge ids (when flipped) so they're consistent" do
      #
      # end
    end
  end
end
