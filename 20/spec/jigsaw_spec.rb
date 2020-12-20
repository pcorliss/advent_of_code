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

    describe "#orient!" do
      it "sets the corner first" do
        expect(ad.orient!.first.id).to eq(1951)
      end

      it "finds the next adjoining tile" do
        expect(ad.orient![1].id).to eq(2729)
      end

      it "rotates and flips the tile to conform" do
        expected_tile_grid = <<~EOS
          ####....#.
          .#####..#.
          #..#.#.##.
          #.###...##
          .##.#.##..
          ..####..##
          .##.##....
          ##.#..#..#
          #....#....
          ......#..#
        EOS
        expected_tile_grid = expected_tile_grid.lines.map(&:chomp)
        expect(ad.orient![1].grid).to eq(expected_tile_grid)
      end

      it "breaks and goes to the next row" do
        expect(ad.orient![2].id).to eq(2971)
        expect(ad.orient![3].id).to eq(2311)
      end

      it "creates a valid grid" do
        expect(ad.orient!.map(&:id)).to eq([
          1951, 2729, 2971,
          2311, 1427, 1489,
          3079, 2473, 1171,
        ])
      end
    end

    describe "#get" do
      it "gets an individual char without borders" do
        expect(ad.get(0,0)).to eq('.')
        expect(ad.get(1,0)).to eq('#')
        expect(ad.get(1,1)).to eq('#')
        expect(ad.get(0,1)).to eq('#')
      end

      it "handles tiles at the other end of the board" do
        expect(ad.get(23,23)).to eq('#')
        expect(ad.get(22,23)).to eq('.')
        expect(ad.get(22,22)).to eq('#')
        expect(ad.get(23,22)).to eq('#')
      end
    end

    describe "#monster_coords" do
      it "generates all possible monster coords" do
        expect(ad.monster_coords.count).to eq(8)
      end
    end

    context "validation" do
      it "counts the monsters" do
        expect(ad.count_monsters).to eq(2)
      end

      it "counts non monster waves" do
        expect(ad.waves).to eq(273)
      end
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

    describe "#rotate!" do
      it "rotates the grid" do
        expected = <<~EOS
          ##.
          .#.
          ###
        EOS
        expected = expected.lines.map(&:chomp)
        expect(tile.rotate!).to eq(expected)
        expect(tile.grid).to eq(expected)
      end
    end

    describe "#flip!" do
      it "flips the grid horizontally" do
        expected = <<~EOS
          #..
          ###
          #.#
        EOS
        expected = expected.lines.map(&:chomp)
        expect(tile.flip!).to eq(expected)
        expect(tile.grid).to eq(expected)
      end

      it "rotating it twice and flipping is the same as flipping vertically" do
        expected = <<~EOS
          #.#
          ###
          ..#
        EOS
        expected = expected.lines.map(&:chomp)
        tile.rotate!
        tile.rotate!
        expect(tile.flip!).to eq(expected)
        expect(tile.grid).to eq(expected)
      end
    end

    describe "#edges" do
      it "computes the edge ids for four sides" do
        # ..#
        # ###
        # #.#
        expect(tile.edges).to eq([1, 7, 5, 3])
      end
    end

    describe "#absolute_edges" do
      it "computes the edge without the min for better matching" do
        expect(tile.absolute_edges).to eq([1, 7, 5, 3])
      end
    end
  end
end
