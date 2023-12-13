require './reflections.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
    EOS
  }

  describe Advent::Reflections do
    let(:ad) { Advent::Reflections.new(input) }

    describe "#new" do
      it "inits grids" do
        expect(ad.grids.count).to eq(2)
        expect(ad.grids.first[0,0]).to eq('#')
        expect(ad.grids.last[1,1]).to eq('.')
      end
    end

    describe "#reflection_point" do
      it "returns the reflection point for a group of numbers" do
        expect(ad.reflection_point([77, 12, 115, 33, 82, 82, 33, 115, 12])).to eq(5)
      end

      it "returns nil if there is no reflection point" do
        expect(ad.reflection_point([77, 12, 115, 33, 82, 82, 33, 115, 99])).to be_nil
      end

      it "handles a shorter left hand side" do
        expect(ad.reflection_point([115, 33, 82, 82, 33, 115, 12])).to eq(3)
      end
    end

    describe "#reflection" do
      it "returns the direction and offset of the reflection point of a vertical line" do
        expect(ad.reflection(ad.grids.first)).to eq([:y, 5])
      end

      it "returns the direction and offset of the reflection point of a horizontal line" do
        expect(ad.reflection(ad.grids.last)).to eq([:x, 4])
      end
    end

    describe "#reflection_sum" do
      it "returns the sum of the reflection points" do
        # add 100 multiplied by the number of rows above each horizontal line of reflection.
        # add up the number of columns to the left of each vertical line of reflection;
        expect(ad.reflection_sum).to eq(405)
      end
    end

    context "validation" do
    end
  end
end
