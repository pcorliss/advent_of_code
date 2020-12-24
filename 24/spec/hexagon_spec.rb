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

    describe "#adjacent" do
      it "returns the 6 neighbor coords of a coordinate" do
        expect(ad.adjacent(0,0)).to eq([ [1,0], [-1,0], [0,-1], [-1,-1], [0,1], [-1,1], ])
      end

      it "returns the 6 neighbor coords of a shifted y hexagonal coordinate" do
        expect(ad.adjacent(0,1)).to eq([ [1,1], [-1,1], [1,0], [0,0], [1,2], [0,2], ])
      end
    end
    describe "#day!" do
      it "increments the day" do
        ad.day!
        expect(ad.day).to eq(1)
      end

      it "it doesn't flip black tiles if there is one black tile next to it" do
        ad.flip!([])
        ad.flip!(["w"])
        ad.day!
        expect(ad.grid[[0,0]]).to eq(1)
      end

      it "it doesn't flip black tiles if there is two black tile next to it" do
        ad.flip!([])
        ad.flip!(["w"])
        ad.flip!(["e"])
        ad.day!
        expect(ad.grid[[0,0]]).to eq(1)
      end

      it "it flips black tiles if there is zero black tile next to it" do
        ad.flip!([])
        ad.day!
        expect(ad.grid[[0,0]]).to eq(2)
      end

      it "it flips black tiles if there is three black tile next to it" do
        ad.flip!([])
        ad.flip!(["nw"])
        ad.flip!(["w"])
        ad.flip!(["ne"])
        ad.day!
        expect(ad.grid[[0,0]]).to eq(2)
      end


      it "it flips white tiles if there are 2 black tiles adjacent" do
        ad.flip!(["nw"])
        ad.flip!(["ne"])
        ad.day!
        expect(ad.grid[[0,0]]).to eq(1)
      end

      it "it doesn't flip white tiles if there are 1 black tiles adjacent" do
        ad.flip!(["ne"])
        ad.day!
        expect(ad.grid[[0,0]]).to be_nil
      end

      it "it doesn't flip white tiles if there are 3 black tiles adjacent" do
        ad.flip!(["nw"])
        ad.flip!(["w"])
        ad.flip!(["ne"])
        ad.day!
        expect(ad.grid[[0,0]]).to be_nil
      end

      it "returns the number of black tiles" do
        ad.flip!([])
        expect(ad.day!).to eq(0)
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

      it "flips tiles on subsequent days" do
        ad.run!
        expect(ad.day!).to eq(15)
        expect(ad.day!).to eq(12)
        expect(ad.day!).to eq(25)
        expect(ad.day!).to eq(14)
        expect(ad.day!).to eq(23)
        expect(ad.day!).to eq(28)
        expect(ad.day!).to eq(41)
        expect(ad.day!).to eq(37)
        expect(ad.day!).to eq(49)
        expect(ad.day!).to eq(37)
      end

      {
        1 => 15,
        2 => 12,
        3 => 25,
        4 => 14,
        5 => 23,
        6 => 28,
        7 => 41,
        8 => 37,
        9 => 49,
        10 => 37,
        20 => 132,
        30 => 259,
        40 => 406,
        50 => 566,
        60 => 788,
        70 => 1106,
        80 => 1373,
        90 => 1844,
        100 => 2208,
      }.each do |days, black_tiles|
        it "after #{days} days #{black_tiles} black tiles will be flipped" do
          ad.run!
          (days-1).times { ad.day! }
          expect(ad.day!).to eq(black_tiles)
        end
      end
    end
  end
end
