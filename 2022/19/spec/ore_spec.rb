require './ore.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
    EOS
  }

  describe Advent::Ore do
    let(:ad) { Advent::Ore.new(input) }

    describe "#new" do
      it "inits blueprints" do
        expect(ad.blueprints.count).to eq(2)
        expect(ad.blueprints.last[:id]).to eq(2)
      end

      it "adds ore robot costs" do
        expect(ad.blueprints.first[:ore]).to eq({ore: 4})
        expect(ad.blueprints.last[:ore]).to eq({ore: 2})
      end

      it "adds clay robot costs" do
        expect(ad.blueprints.first[:clay]).to eq({ore: 2})
        expect(ad.blueprints.last[:clay]).to eq({ore: 3})
      end

      it "adds obsidian robot costs" do
        expect(ad.blueprints.first[:obsidian]).to eq({ore: 3, clay: 14})
        expect(ad.blueprints.last[:obsidian]).to eq({ore: 3, clay: 8})
      end

      it "adds geode robot costs" do
        expect(ad.blueprints.first[:geode]).to eq({ore: 2, obsidian: 7})
        expect(ad.blueprints.last[:geode]).to eq({ore: 3, obsidian: 12})
      end

      it "inits a starting loadout" do
        expect(ad.blueprints.first[:starting_robots]).to eq(:ore => 1)
        expect(ad.blueprints.last[:starting_robots]).to eq(:ore => 1)
      end
    end

    context "validation" do
    end
  end
end
