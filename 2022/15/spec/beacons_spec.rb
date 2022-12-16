require './beacons.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    Sensor at x=13, y=2: closest beacon is at x=15, y=3
    Sensor at x=12, y=14: closest beacon is at x=10, y=16
    Sensor at x=10, y=20: closest beacon is at x=10, y=16
    Sensor at x=14, y=17: closest beacon is at x=10, y=16
    Sensor at x=8, y=7: closest beacon is at x=2, y=10
    Sensor at x=2, y=0: closest beacon is at x=2, y=10
    Sensor at x=0, y=11: closest beacon is at x=2, y=10
    Sensor at x=20, y=14: closest beacon is at x=25, y=17
    Sensor at x=17, y=20: closest beacon is at x=21, y=22
    Sensor at x=16, y=7: closest beacon is at x=15, y=3
    Sensor at x=14, y=3: closest beacon is at x=15, y=3
    Sensor at x=20, y=1: closest beacon is at x=15, y=3
    EOS
  }

  describe Advent::Beacons do
    let(:ad) { Advent::Beacons.new(input) }

    describe "#new" do
      it "inits a grid of sensors" do
        expect(ad.grid[14,17]).to eq('S')
        expect(ad.grid[20,1]).to eq('S')
        expect(ad.grid.find_all('S').count).to eq(14)
      end

      it "inits a grid of beacons" do
        expect(ad.grid[-2,15]).to eq('B')
        expect(ad.grid[15,3]).to eq('B')
        expect(ad.grid.find_all('B').count).to eq(6)
      end

      it "inits sensor beacon pairs" do
        expect(ad.sb_pairs.first).to eq([[2,18],[-2,15]])
        expect(ad.sb_pairs.count).to eq(14)
      end
    end

    describe "#sensor_intervals" do
      it "returns a list of ranges for sensors that overlap the row" do
        expect(ad.sensor_intervals(10)).to include((2..14))
        # puts ad.sensor_intervals(10).inspect
        # puts ad.sensor_intervals(11).inspect
      end

      it "omits sensors not in range" do
        expect(ad.sensor_intervals(10000000)).to be_empty
      end
    end

    describe "#collapsed_intervals" do
      it "returns a single interval" do
        expect(ad.collapsed_intervals(10).count).to eq(1)
      end

      it "returns intervals with a gap" do
        expect(ad.collapsed_intervals(11).count).to eq(2)
      end
    end

    describe "#null_positions" do
      it "when y is 10 is returns 26" do
        expect(ad.null_positions(10).count).to eq(26)
      end
    end

    describe "#tuning_frequency" do
      it "returns the tuning frequency" do
        expect(ad.tuning_frequency([14,11])).to eq(56000011)
      end
    end

    describe "#find_beacon" do
      it "returns the beacon" do
        expect(ad.find_beacon([0,0],[20,20])).to eq([14,11])
      end
    end

    context "validation" do
    end
  end
end
