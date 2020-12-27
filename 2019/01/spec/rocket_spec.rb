require './rocket.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
12
14
1969
100756
    EOS
  }

  describe Advent::Rocket do
    let(:ad) { Advent::Rocket.new(input) }

    describe "#new" do
      it "loads a bunch of masses" do
        expect(ad.masses).to contain_exactly(12,14,1969,100756)
      end
    end

    describe "#fuel" do
      {
        12 => 2,
        14 => 2,
        1969 => 654,
        100756 => 33583,
      }.each do |mass, fuel|
        it "returns #{fuel} for a mass of #{mass}" do
          expect(ad.fuel(mass)).to eq(fuel)
        end
      end

      it "doesn't return a negative number ofr small amounts of fuel" do
        expect(ad.fuel(1)).to eq(0)
      end
    end

    describe "recursive_fuel" do
      {
        14 => 2,
        1969 => 966,
        100756 => 50346,
      }.each do |mass, fuel|
        it "returns #{fuel} for a mass of #{mass}" do
          expect(ad.recursive_fuel(mass)).to eq(fuel)
        end
      end
    end

    describe "#total_fuel" do
      it "returns the total fuel needs" do
        expect(ad.total_fuel).to eq(34241)
      end
    end
    context "validation" do
    end
  end
end
