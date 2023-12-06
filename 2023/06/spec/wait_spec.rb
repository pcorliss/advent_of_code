require './wait.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Time:      7  15   30
Distance:  9  40  200
    EOS
  }

  describe Advent::Wait do
    let(:ad) { Advent::Wait.new(input) }

    describe "#new" do
      it "loads the input and parses it" do
        expect(ad.races.first.time).to eq(7)
        expect(ad.races.first.record).to eq(9)
        expect(ad.races[2].time).to eq(30)
        expect(ad.races[2].record).to eq(200)
      end

      it "smushes the inoput together for part 2" do
        expect(ad.races.last.time).to eq(71530)
        expect(ad.races.last.record).to eq(940200)
      end
    end

    describe "#number_of_ways" do
      [ 4, 8, 9, 71503 ].each_with_index do |ways, idx|
        it "returns the number of ways to win, #{ways}, for race #{idx}" do
          expect(ad.number_of_ways(ad.races[idx])).to eq(ways)
        end
      end
    end

    context "validation" do
      it "returns the product of the number of ways to win for part 1" do
        expect(ad.number_of_ways_product).to eq(288)
      end
    end
  end
end
