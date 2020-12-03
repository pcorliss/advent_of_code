require '../traj.rb'
require 'rspec'
require 'pry'

describe Advent::Three do
  let(:input) {
    # Repeats to the right infinetly
    <<~EOS
      ..##.......
      #...#...#..
      .#....#..#.
      ..#.#...#.#
      .#...##..#.
      ..#.##.....
      .#.#.#....#
      .#........#
      #.##...#...
      #...##....#
      .#..#...#.#
    EOS
  }
  let(:ad) { Advent::Three.new(input) }

  # Start in the top left corner need to get to the bottom
  describe "#new" do
    it "sets the height" do
      expect(ad.height).to eq(11)
    end

    it "sets the width" do
      expect(ad.width).to eq(11)
    end

    it "instantiates a 2D array" do
      expect(ad.input).to be_a(Array)
      expect(ad.input.first).to be_a(Array)
    end

    it "sets the position to 0,0" do
      expect(ad.pos).to eq([0,0])
    end

    it "sets the tree counter to 0" do
      expect(ad.trees).to eq(0)
    end

    it "sets the tree counter to 1 if it starts on a tree" do
      ad = Advent::Three.new("#")
      expect(ad.trees).to eq(1)
    end

    it "takes an optional slope" do
      ad = Advent::Three.new(input, 1, 1)
      ad.step!
      expect(ad.pos).to eq([1,1])
    end
  end

  describe "#step!" do
    it "changes the position" do
      expect(ad.pos).to eq([0,0])
      ad.step!
      expect(ad.pos).to eq([3, 1])
    end

    it "increments the tree counter" do
      ad.step!
      ad.step!
      expect(ad.trees).to eq(1)
      expect(ad.pos).to eq([6, 2])
    end

    it "stops at the bottom" do
      11.times { ad.step! }
      expect do
        ad.step!
      end.to_not change { ad.pos}
    end
  end

  describe "#tree?" do
    it "returns false if there's no tree" do
      expect(ad.tree?).to be_falsey
    end

    it "returns true if there is a tree" do
      ad = Advent::Three.new("#")
      expect(ad.tree?).to be_truthy
    end

    it "handles horizontal bounds" do
      4.times { ad.step! }
      expect(ad.tree?).to be_truthy
    end
  end

  describe "#bottom?" do
    it "returns false if not at the bottom" do
      expect(ad.bottom?).to be_falsey
    end

    it "returns true if at the bottom" do
      10.times { ad.step! }
      expect(ad.bottom?).to be_truthy
    end
  end

  describe "#go_to_bottom!" do
    it "cycles through the steps to the bottom" do
      ad.go_to_bottom!
      expect(ad.pos).to eq([30,10])
    end

    it "produces a tree count" do
      ad.go_to_bottom!
      expect(ad.trees).to eq(7)
    end
  end

  context "validation" do
    {
      [1, 1] => 2,
      [3, 1] => 7,
      [5, 1] => 3,
      [7, 1] => 4,
      [1, 2] => 2,
    }.each do |slope, trees|
      it "produces #{trees} trees for slope of #{slope}" do
        ad = Advent::Three.new(input, *slope)
        ad.go_to_bottom!
        expect(ad.trees).to eq(trees)
      end
    end
  end
end

