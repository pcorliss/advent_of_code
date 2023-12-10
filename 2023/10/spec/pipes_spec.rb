require './pipes.rb'
require 'rspec'
require 'pry'

describe Advent do
  let(:input) {
    <<~EOS
    -L|F7
    7S-7|
    L|7||
    -L-J|
    L|-JF
    EOS
  }

  let(:input_2) {
    <<~EOS
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    EOS
  }

  describe Advent::Pipes do
    let(:ad) { Advent::Pipes.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
      end

      it "fills the grid with pipes" do
        expect(ad.grid[1,1]).to eq('S')
        expect(ad.grid[2,1]).to eq('-')
        expect(ad.grid[3,1]).to eq('7')
        expect(ad.grid[1,2]).to eq('|')
        expect(ad.grid[2,2]).to eq('7')
        expect(ad.grid[3,2]).to eq('|')
        expect(ad.grid[1,3]).to eq('L')
        expect(ad.grid[2,3]).to eq('-')
        expect(ad.grid[3,3]).to eq('J')
      end
    end

    describe "#starting_point" do
      it "returns the starting point" do
        expect(ad.starting_point).to eq([1,1])
      end
    end

    describe "#starting_directions" do
      it "returns cells with valid directions based on their pipes" do
        # ad.debug!
        expect(ad.starting_directions).to match_array([[ 1, 0],[ 0, 1]])
      end
    end

    describe "#first_steps" do
      it "returns the first steps" do
        expect(ad.first_steps).to match_array([[2,1],[1,2]])
      end
    end

    describe "#walk" do
      it "returns the steps to the furthest point from start" do
        expect(ad.walk).to eq(4)
      end

      it "handles a more complicated input" do
        ad = Advent::Pipes.new(input_2)
        expect(ad.walk).to eq(8)
      end
    end

    context "validation" do
    end
  end
end
