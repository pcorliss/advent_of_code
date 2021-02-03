require './packages.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) { ((1..5).to_a + (7..11).to_a).map(&:to_s).join("\n") }

  describe Advent::Packages do
    let(:ad) { Advent::Packages.new(input) }

    describe "#new" do
      it "loads packages" do
        expect(ad.packages).to eq([1,2,3,4,5,7,8,9,10,11])
        expect(ad.packages.count).to eq(10)
      end
    end

    describe "#configurations" do
      it "returns the shortest combo that has the right weight" do
        expect(ad.configurations).to eq([[9,11]])
      end

      it "takes an argument for the number of groups" do
        expect(ad.configurations(4)).to contain_exactly(
          contain_exactly(11,4),
          contain_exactly(10,5),
          contain_exactly(8,7),
        )
      end
    end

    context "validation" do
    end
  end
end
