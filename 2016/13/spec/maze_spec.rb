require './maze.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    10
    EOS
  }

  describe Advent::Maze do
    let(:ad) { Advent::Maze.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
      end

      it "inits a magic number" do
        expect(ad.magic).to eq(10)
      end
    end

    describe "#wall?" do
      it "returns false if there's open space" do
        expect(ad.wall?([1,1])).to be_falsey
      end

      it "returns true if there's a wall" do
        expect(ad.wall?([1,0])).to be_truthy
      end
    end

    describe "#steps" do
      {
        [1,1] => 0,
        [1,2] => 1,
        [2,2] => 2,
        [3,2] => 3,
        [3,3] => 4,
        [3,4] => 5,
        [4,4] => 6,
        [4,5] => 7,
        [5,5] => 8,
        [6,5] => 9,
        [6,4] => 10,
        [7,4] => 11,
      }.each do |pos, steps|
        it "returns the number of steps #{steps} to reach a particular point #{pos}" do
          expect(ad.steps(pos)).to eq(steps)
        end
      end

      it "returns the number of distinct locations visited once max_steps has been reached" do
          expect(ad.steps([1000,1000], 10)).to eq(18)
      end
    end

    context "validation" do
    end
  end
end
