require '../hexagon.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
    EOS
  }

  describe Advent::Hexagon do
    let(:ad) { Advent::Hexagon.new(input) }

    describe "#new" do
      it "loads a list of instructions" do
        expect(ad.instructions).to be_a(Array)
        expect(ad.instructions.count).to eq(20)
      end

      it "separates the instructions into directions" do
        expect(ad.instructions[2]).to eq(%w( se sw ne sw sw se nw w nw se ))
      end

      it "inits an empty grid" do
        expect(ad.grid).to eq({})
      end
    end

    describe "#navigate" do
      {
        ["e"] => [1,0],
        ["w"] => [-1,0],
        ["ne"] => [0,-1],
        ["nw"] => [-1,-1],
        ["se"] => [0,1],
        ["sw"] => [-1,1],
      }.each do |directions, expected|
        it "takes a basic direction #{directions} and returns the expected coordinate #{expected}" do
          expect(ad.navigate(directions)).to eq(expected)
        end
      end

      {
        ["nw", "sw"] => [-1,0],
        ["sw", "nw"] => [-1,0],
        ["ne", "se"] => [1,0],
        ["se", "ne"] => [1,0],
      }.each do |directions, expected|
        it "handles the shifted hexagonal coordinate system #{directions} and returns the expected coordinate #{expected}" do
          # ad.debug = true
          expect(ad.navigate(directions)).to eq(expected)
        end
      end

      {
        ["e", "se", "w"] => [0,1],
        ["nw", "w", "sw", "e", "e"] => [0,0],
      }.each do |directions, expected|
        it "takes compound directions #{directions} and returns the expected coordinate #{expected}" do
          # ad.debug = true
          expect(ad.navigate(directions)).to eq(expected)
        end
      end

      # it "takes a list of instructions and returns the x,y coordinates" do
      #   expect(ad.navigate([])).to eq()
      # end
    end

    describe "#flip!" do
      it "changes the state of a tile" do
        ad.flip!(["nw", "w", "sw", "e", "e"])
        expect(ad.grid[[0,0]]).to eq(1)
      end

      it "increments the counter of a tile" do
        ad.flip!(["nw", "w", "sw", "e", "e"])
        ad.flip!([])
        expect(ad.grid[[0,0]]).to eq(2)
      end
    end

    context "validation" do
      it "runs the sample input and flips the correct tiles" do
        ad.run!
        tiles = ad.grid.values
        black_tiles = tiles.count {|t| t % 2 == 1}
        white_tiles = tiles.count {|t| t % 2 == 0}
        expect(ad.grid.values.sum).to eq(20)
        expect(black_tiles).to eq(10)
        expect(white_tiles).to eq(5)
      end
    end
  end
end
