require './liters.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      20
      15
      10
      5
      5
    EOS
  }

  describe Advent::Liters do
    let(:ad) { Advent::Liters.new(input) }

    describe "#new" do
      it "inits a list of containers" do
        expect(ad.containers).to contain_exactly(20,15,10,5,5)
      end
    end

    describe "#combos" do
      it "returns a list of combinations to reach the target" do
        expect(ad.combos(25)).to contain_exactly(
          [15,10],
          [20, 5],
          [20, 5],
          [15, 5, 5],
        )
      end
    end

    context "validation" do
    end
  end
end
