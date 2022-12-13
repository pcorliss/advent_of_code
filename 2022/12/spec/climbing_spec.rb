require './climbing.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
    EOS
  }

  let(:crevasse) {
    <<~EOS
Sabqponm
abcryxxl
accszExk
ddctuvwj
addefghi
    EOS
  }
  describe Advent::Climbing do
    let(:ad) { Advent::Climbing.new(input) }

    describe "#new" do
      it "instantiates a grid" do
        expect(ad.grid.width).to eq(8)
        expect(ad.grid[1,1]).to eq('b')
      end

      it "sets the start point" do
        expect(ad.start).to eq([0,0])
      end

      it "replaces the start point with the elevation" do
        expect(ad.grid[0,0]).to eq('a')
      end

      it "sets the end point" do
        expect(ad.end).to eq([5,2])
      end

      it "replaces the end point with the elevation" do
        expect(ad.grid[5,2]).to eq('z')
      end
    end

    describe "#shortest_path" do
      it "finds the path from the start to an adjacent cell" do
        # ad.debug!
        expect(ad.shortest_path([[[0,0]]],[1,0])).to eq([[0,0],[1,0]])
      end

      it "finds the path from the start to a cell two steps away" do
        # ad.debug!
        expect(ad.shortest_path([[[0,0]]],[1,1]).count).to eq(3)
      end

      it "finds the path from the start to a cell several steps away" do
        # ad.debug!
        expect(ad.shortest_path([[[0,0]]],[2,4]).count).to eq(7)
      end

      it "returns the path from start and end" do
        expect(ad.shortest_path.count).to eq(32)
      end
    end

    describe "#find_best_starting_position" do
      it "returns best starting position at elevation a" do
        # ad.debug!
        expect(ad.find_best_starting_position).to eq([0,4])
      end

      it "handles starting locations without a path" do
        ad = Advent::Climbing.new(crevasse)
        expect(ad.find_best_starting_position).to eq([1,0])
      end
    end

    context "validation" do
    end
  end
end
