require '../bus.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    939
    7,13,x,x,59,x,31,19
    EOS
  }

  describe Advent::Bus do
    let(:ad) { Advent::Bus.new(input) }

    describe "#new" do
      it "sets a start time" do
        expect(ad.start).to eq(939)
      end

      it "sets a collection of busses" do
        expect(ad.bus).to eq([7, 13, 59, 31, 19])
      end
    end

    describe "#earliest_bus" do
      it "returns the earliest bus id and the time until it arrives" do
        expect(ad.earliest_bus).to eq([59, 5])
      end
    end

    context "validation" do
      {
        "17,x,13,19" => 3417,
        "67,7,59,61" => 754018,
        "67,x,7,59,61" => 779210,
        "7,13,x,x,59,x,31,19" => 1068781,
        "67,7,x,59,61" => 1261476,
        "1789,37,47,1889" => 1202161486,
      }.each do |inp, expected|
        it "validates that #{inp} returns #{expected}" do
          ad = Advent::Bus.new("0\n#{inp}")
          expect(ad.contest).to eq(expected)
        end
      end
    end
  end
end
