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
    let(:blueprint) { ad.blueprints.first }
    let(:blueprint2) { ad.blueprints.last }

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
        expect(ad.blueprints.first[:robots]).to eq(ore: 1, clay: 0, obsidian: 0, geode: 0)
        expect(ad.blueprints.last[:robots]).to eq(ore: 1, clay: 0, obsidian: 0, geode: 0)
      end

      it "inits starting inventory" do
        expect(ad.blueprints.first[:inventory]).to eq({ore: 0, clay: 0, obsidian: 0, geode: 0})
        expect(ad.blueprints.last[:inventory]).to eq({ore: 0, clay: 0, obsidian: 0, geode: 0})
      end

      it "inits minute" do
        expect(ad.blueprints.first[:minute]).to eq(0)
        expect(ad.blueprints.last[:minute]).to eq(0)
      end
    end

    describe "#blueprint_options" do

# Blueprint 1:
# Each ore robot costs 4 ore.
# Each clay robot costs 2 ore.
# Each obsidian robot costs 3 ore and 14 clay.
# Each geode robot costs 2 ore and 7 obsidian.
      it "returns one option if you can't afford anything" do
        options = ad.blueprint_options(blueprint)
        expect(options.count).to eq(1)
        expect(options.first[:robots]).to eq(blueprint[:robots])
      end

      it "returns the base option and a build option" do
        blueprint[:inventory][:ore] = 2 
        options = ad.blueprint_options(blueprint)
        expect(options.count).to eq(2)
        expect(options.first[:robots]).to eq(blueprint[:robots])
        expect(options.last[:robots][:clay]).to eq(1)
        expect(options.last[:inventory][:ore]).to eq(1)
      end

      it "spends multiple types of resources" do
        blueprint[:inventory][:ore] = 2 
        blueprint[:inventory][:obsidian] = 7 
        options = ad.blueprint_options(blueprint)
        expect(options.count).to eq(3)
        expect(options.last[:robots][:geode]).to eq(1)
        expect(options.last[:inventory][:ore]).to eq(1)
        expect(options.last[:inventory][:obsidian]).to eq(0)
      end

      it "increments resources" do
        blueprint[:robots] = {ore: 1, clay: 2, obsidian: 3, geode: 4}
        options = ad.blueprint_options(blueprint)
        ore = options.map {|bp| bp[:inventory][:ore]}.max
        clay = options.map {|bp| bp[:inventory][:clay]}.max
        obsidian = options.map {|bp| bp[:inventory][:obsidian]}.max
        geode = options.map {|bp| bp[:inventory][:geode]}.max
        expect(ore).to eq(1)
        expect(clay).to eq(2)
        expect(obsidian).to eq(3)
        expect(geode).to eq(4)
      end

      it "increments minute" do
        expect(ad.blueprint_options(blueprint).first[:minute]).to eq(1)
      end

      it "only builds a single robot at a time" do
        blueprint[:inventory][:ore] = 4_000
        options = ad.blueprint_options(blueprint)
        clay_robots = options.map {|bp| bp[:robots][:clay]}.max
        expect(clay_robots).to eq(1)
      end

      it "doesn't mutate the original" do
        ad.blueprint_options(blueprint)
        expect(blueprint[:minute]).to eq(0)
      end
    end

    describe "#optimize_blueprint" do
      it "returns the best blueprint" do
        # ad.debug!
        best = ad.optimize_blueprint(blueprint)
        expect(best[:inventory][:geode]).to eq(9)
      end

      it "returns the best blueprint for id 2" do
        # ad.debug!
        best = ad.optimize_blueprint(blueprint2)
        expect(best[:inventory][:geode]).to eq(12)
      end
    end

    describe "#quality_levels" do
      it "returns the sum of all quality levels" do
        expect(ad.quality_levels).to eq(33)
      end
    end

    context "validation" do
    end
  end
end
