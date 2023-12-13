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

  let(:input_rotated) {
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
    
    .#.##.#.#
    .##..##..
    .#.##.#..
    #......##
    #......##
    .#.##.#..
    .##..##.#
    
    #..#....#
    ###..##..
    .##.#####
    .##.#####
    ###..##..
    #..#....#
    #..##...#
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

      context "smudges" do
        it "allows a single bit to be smudged" do
          expect(ad.reflection_point([205, 180, 259, 259, 180, 204, 181], true)).to eq(3)
        end

        it "handles larger differences than 1" do
          expect(ad.reflection_point([305, 289, 460, 223, 223, 460, 289], true)).to eq(1)
        end

        it "still returns nil if it can't smudge exactly one spot" do
          expect(ad.reflection_point([77, 12, 115, 33, 82, 82, 33, 115, 12], true)).to be_nil
          expect(ad.reflection_point([91, 24, 60, 60, 25, 67, 60, 60, 103], true)).to be_nil
        end

        it "handles an example where the different is a power of 2 properly" do
          expect(ad.reflection_point([39, 31, 475, 43, 487, 495, 448, 8, 380, 439, 416, 471, 424], true)).to be_nil
        end
      end
    end

    describe "#reflection" do
      it "returns the direction and offset of the reflection point of a vertical line" do
        expect(ad.reflection(ad.grids.first)).to eq([:y, 5])
      end

      it "returns the direction and offset of the reflection point of a horizontal line" do
        expect(ad.reflection(ad.grids.last)).to eq([:x, 4])
      end

      context "smudges" do
        it "returns new values when smudge is passed" do
          expect(ad.reflection(ad.grids.first, true)).to eq([:x, 3])
          expect(ad.reflection(ad.grids.last, true)).to eq([:x, 1])
        end
      end
    end

    describe "#reflection_sum" do
      it "returns the sum of the reflection points" do
        # add 100 multiplied by the number of rows above each horizontal line of reflection.
        # add up the number of columns to the left of each vertical line of reflection;
        # ad.debug!
        expect(ad.reflection_sum).to eq(405)
      end

      it "handles rotated examples" do
        ad = Advent::Reflections.new(input_rotated)
        expect(ad.reflection_sum).to eq(709)
      end

      context "smudges" do
        it "handles smudges" do
          expect(ad.reflection_sum(true)).to eq(400)
        end

        it "handles rotated examples" do
          ad = Advent::Reflections.new(input_rotated)
          expect(ad.reflection_sum(true)).to eq(1400)
        end
      end
    end

    context "validation" do
    end
  end
end
