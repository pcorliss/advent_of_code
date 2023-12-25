require './hail.rb'
require 'rspec'
require 'pry'

describe Advent do
  let(:real_input) { File.read('input.txt') }
  let(:input) {
    <<~EOS
    19, 13, 30 @ -2,  1, -2
    18, 19, 22 @ -1, -1, -2
    20, 25, 34 @ -2, -2, -4
    12, 31, 28 @ -1, -2, -1
    20, 19, 15 @  1, -5, -3
    EOS
  }

  describe Advent::Hail do
    let(:ad) { Advent::Hail.new(input) }

    describe "#new" do
      it "inits hail" do
        expect(ad.hail.count).to eq(5)
        expect(ad.hail.first).to eq([[19,13,30],[-2, 1, -2]])
        expect(ad.hail.last).to eq([[20,19,15],[ 1,-5, -3]])
      end
    end

    describe "#fit_line" do
      it "returns coefficients for a line, 0 = ax + by + c" do
        expect(ad.fit_line(ad.hail.first)).to eq([-0.5, -1, 22.5])
      end
    end

    describe "#intersection" do
      it "returns the intersection of two lines" do
        line1 = ad.fit_line(ad.hail[0])
        line2 = ad.fit_line(ad.hail[1])
        x, y = ad.intersection(line1, line2)
        expect(x).to be_within(0.001).of(14.333)
        expect(y).to be_within(0.001).of(15.333)
      end
    end

    describe "#in_the_past?" do
      it "returns true if the intersection is in the past" do
        # Hailstone A: [[18, 19, 22], [-1, -1, -2]]
        # Hailstone B: [[20, 19, 15], [1, -5, -3]]
        # Hailstones' paths will cross inside the test area (at [19.666666666666668, 20.666666666666668]).
        h1 = ad.hail[1]
        h2 = ad.hail[4]
        l1 = ad.fit_line(h1)
        l2 = ad.fit_line(h2)
        x, y = ad.intersection(l1, l2)
        # ad.debug!
        expect(ad.in_the_past?(h1, h2, x, y)).to be_truthy
      end

      it "returns true if the intersection is in the past" do
        # Hailstone A: [[19, 13, 30], [-2, 1, -2]]
        # Hailstone B: [[20, 19, 15], [1, -5, -3]]
        # Hailstones' paths will cross inside the test area (at [21.444444444444443, 11.777777777777779]).
        h1 = ad.hail[0]
        h2 = ad.hail[4]
        l1 = ad.fit_line(h1)
        l2 = ad.fit_line(h2)
        x, y = ad.intersection(l1, l2)
        # ad.debug!
        expect(ad.in_the_past?(h1, h2, x, y)).to be_truthy
      end
    end

    describe "#matching_intersections" do
      it "#returns intersections within bounding box" do
        # ad.debug!
        expect(ad.matching_intersections([[7,7],[27,27]])).to eq(2)
      end
    end

    describe "#solve_axis" do
      it "returns the position and velocity for an axis" do
        # ad.debug!
        expect(ad.solve_rock([-3, 1, 2])).to eq([24, 13, 10])
      end
    end

    describe "#full_solve" do
      it "returns the position and velocity for an axis" do
        # ad.debug!
        expect(ad.full_solve).to eq([24, 13, 10])
      end
    end

    context "validation" do
      it "input file present" do
        expect(real_input).to_not be_empty
        # binding.pry
      end
    end
  end
end
