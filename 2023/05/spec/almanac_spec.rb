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

    context "validation" do

      it "returns the lowest location for part 1" do
        expect(ad.lowest_location).to eq(35)
      end
    end
  end
end
