require './almanac.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
    EOS
  }

  describe Advent::Almanac do
    let(:ad) { Advent::Almanac.new(input) }

    describe "#new" do
      it "loads seeds" do
        expect(ad.seeds).to eq([79,14,55,13])
      end

      it "loads maps" do
        # [source-to-dest]
        # [dest range, source range, inclusive size]
        expect(ad.maps['seed-to-soil']).to eq([[50,98,2],[52,50,48]])
        expect(ad.map_map['seed']).to eq('soil')
        expect(ad.map_map['humidity']).to eq('location')
      end
    end

    describe '#map_value' do
      [
        ['seed','soil',79,81],
        ['soil','fertilizer',81,81],
        ['fertilizer','water',81,81],
        ['water','light',81,74],
        ['light','temperature',74,78],
        ['temperature','humidity',78,78],
        ['humidity','location',78,82],
      ].each do |source, dest, value, expected|
        it "maps, #{source}-to-#{dest}, value, #{value}, to #{expected}" do
          expect(ad.map_value(source,dest,value)).to eq(expected)
        end
      end
    end

    describe "#seed_to_location" do
      {
        79 => 82,
        14 => 43,
        55 => 86,
        13 => 35,
      }.each do |seed, location|
        it "returns the location, #{location}, for a seed, #{seed}" do
          expect(ad.seed_to_location(seed)).to eq(location)
        end
      end
    end

    describe "#new_ranges" do
      # 1:1 range
      it "handles ranges that don't overlap" do
        expect(ad.new_ranges([1...10],[[12, 20, 10]])).to match_array([1...10])
      end

      # 1 new range
      it "handles ranges that are entirely covered by the destination range" do
        expect(ad.new_ranges([5...10],[[30, 0, 20]])).to match_array([35...40])
      end

      # 3 new ranges
      it "handles ranges that eclipse the destination range" do
        expect(ad.new_ranges([5...10],[[30, 6, 2]])).to match_array([5...6, 30...32, 8...10])
      end

      it "handles ranges that eclipse the destination range and are on the edge" do
        expect(ad.new_ranges([5...10],[[30, 5, 2]])).to match_array([30...32, 7...10])
      end

      it "handles ranges that eclipse the destination range and are on the right edge" do
        expect(ad.new_ranges([5...10],[[30, 8, 2]])).to match_array([5...8, 30...32])
      end

      it "handles ranges on the left-edge" do
        expect(ad.new_ranges([5...10],[[30, 3, 4]])).to match_array([32...34, 7...10])
      end

      it "handles ranges on the right-edge" do
        expect(ad.new_ranges([5...10],[[30, 8, 4]])).to match_array([5...8, 30...32])
      end

      it "doesn't remap already mapped ranges" do
        expect(ad.new_ranges([5...10],[[30, 8, 4],[40, 30, 2]])).to match_array([5...8, 30...32])
      end
    end

    describe "#collapse_ranges" do
      it "returns locations ranges from seed ranges" do
        new_ranges = ad.collapse_ranges
        lowest = new_ranges.sort_by!(&:min).first.first
        expect(lowest).to eq(46)
      end
    end

    context "validation" do

      it "returns the lowest location for part 1" do
        expect(ad.lowest_location).to eq(35)
      end

      it "returns the lowest location for part 2" do
        expect(ad.lowest_location_2).to eq(46)
      end

      it "returns the lowest location for part 2 (optimized)" do
        expect(ad.lowest_location_optimized).to eq(46)
      end
    end
  end
end


###
 ###

 ###
###

###
 # 

 # 
###