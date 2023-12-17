require './crucible.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    2413432311323
    3215453535623
    3255245654254
    3446585845452
    4546657867536
    1438598798454
    4457876987766
    3637877979653
    4654967986887
    4564679986453
    1224686865563
    2546548887735
    4322674655533
    EOS
  }

  let(:optimal_path) {
    <<~EOS
    2>>34^>>>1323
    32v>>>35v5623
    32552456v>>54
    3446585845v52
    4546657867v>6
    14385987984v4
    44578769877v6
    36378779796v>
    465496798688v
    456467998645v
    12246868655<v
    25465488877v5
    43226746555v>
    EOS
  }

  describe Advent::Crucible do
    let(:ad) { Advent::Crucible.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid[0,0]).to eq(2)
        expect(ad.grid[1,1]).to eq(2)
      end
    end

    describe "#path_find" do
      it "finds the optimal path to the end and returns the heat loss" do
        # ad.debug!
        expect(ad.path_find).to eq(102)
      end

      context "minimum and maximum straight movement" do
        it "finds the optimal path to the end and returns the heat loss" do
          # ad.debug!
          expect(ad.path_find(min: 4, max: 10)).to eq(94)
        end

        let(:alternate_input) {
          <<~EOS
          111111111111
          999999999991
          999999999991
          999999999991
          999999999991
          EOS
        }

        it "travels the minimum distance, even at the end" do
          ad = Advent::Crucible.new(alternate_input)
          # ad.debug!
          expect(ad.path_find(min: 4, max: 10)).to eq(71)
        end
      end
    end

    context "validation" do
    end
  end
end
