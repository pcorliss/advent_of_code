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
    end
  end
end
