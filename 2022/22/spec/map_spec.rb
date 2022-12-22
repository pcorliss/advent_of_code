require './map.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
    EOS
  }

  describe Advent::Map do
    let(:ad) { Advent::Map.new(input) }

    describe "#new" do
      it "instantiates a grid with the map" do
        expect(ad.grid[8,0]).to eq('.')
        expect(ad.grid[11,0]).to eq('#')
        expect(ad.grid[14,11]).to eq('#')
        expect(ad.grid[15,11]).to eq('.')
      end

      it "loads instructions" do
        expect(ad.instructions).to start_with( 10, :R, 5, :L)
      end

      it "inits a starting position" do
        expect(ad.pos).to eq([8,0])
      end

      it "inits a direction" do
        expect(ad.dir).to eq(:E)
      end
    end

    describe "#run_instruction" do
      it "moves you forward the number of steps" do
        ad.run_instruction(2)
        expect(ad.pos).to eq([10,0])
      end

      it "doesn't allow movement through walls" do
        ad.run_instruction(3)
        expect(ad.pos).to eq([10,0])
      end

      it "handles wrapping around horizontally" do
        ad.pos = [8,3]
        ad.run_instruction(5)
        expect(ad.pos).to eq([9,3])
      end

      it "handles wrapping around vertically" do
        ad.pos = [5,4]
        ad.dir = :S
        ad.run_instruction(5)
        expect(ad.pos).to eq([5,5])
      end

      it "doesn't move you if there's a wall on the wrapped around side" do
        ad.pos = [0,4]
        ad.dir = :W
        ad.run_instruction(3)
        expect(ad.pos).to eq([0,4])
      end

      it "rotates your direction left" do
        ad.run_instruction(:L)
        expect(ad.dir).to eq(:N)
      end

      it "rotates your direction right" do
        ad.run_instruction(:R)
        expect(ad.dir).to eq(:S)
      end

      it "rotates your direction 360 degrees" do
        4.times { ad.run_instruction(:R) }
        expect(ad.dir).to eq(:E)
      end
    end

    describe "#run" do
      it "runs all the instructions" do
        ad.run
        expect(ad.pos).to eq([7,5])
        expect(ad.dir).to eq(:E)
      end
    end

    describe "#password" do
      it "returns the password" do
        ad.run
        expect(ad.password).to eq(6032)
      end
    end

    context "validation" do
    end
  end
end
