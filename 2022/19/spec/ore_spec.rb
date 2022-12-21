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

  # Next Steps
  # Optimize by creating upper bounds
  # We don't want more than X ore robots if we'll only ever spend X ore per turn
  # We don't want more than X clay robots ...

  # Investigate whatever linear programming is


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

      it "inits minute limit" do
        expect(ad.minutes).to eq(24)
      end


      it "allows setting the minute limit" do
        ad = Advent::Ore.new(input, 32)
        expect(ad.minutes).to eq(32)
      end
    end

    describe "#upper_bound" do
      it "returns the upper bounds on numbers of robots" do
        bounds = ad.upper_bound(blueprint)
        expect(bounds[:ore]).to eq(3)
        expect(bounds[:clay]).to eq(14)
        expect(bounds[:obsidian]).to eq(7)
        expect(bounds[:geode]).to eq(1000)
      end
    end

    describe "#blueprint_options" do
      it "returns an option where you don't build" do
        blueprint[:clay] = {ore: 1_000}
        blueprint[:ore] = {ore: 1_000}
        options = ad.blueprint_options(blueprint)
        expect(options.count).to eq(1)
        expect(options.first[:robots]).to eq(blueprint[:robots])
        expect(options.first[:minute]).to eq(24)
        expect(options.first[:inventory][:ore]).to eq(24)
      end

      it "returns an option where you build an ore robot" do
        # ad.debug!
        blueprint[:clay] = {ore: 1_000}
        options = ad.blueprint_options(blueprint)
        expect(options.count).to eq(2)
        expect(options.first[:robots][:ore]).to eq(2)
        expect(options.first[:minute]).to eq(5) # End of min 5 Begin Min 6
        expect(options.first[:inventory][:ore]).to eq(1)
      end

      it "returns an option where you build a clay robot" do
        # ad.debug!
        options = ad.blueprint_options(blueprint)
        expect(options.count).to eq(3)
       
        opt = options.find { |o| o[:robots][:clay] == 1}
        expect(opt[:robots][:ore]).to eq(1)
        expect(opt[:robots][:clay]).to eq(1)
        expect(opt[:minute]).to eq(3) # End of min 3 / Begin of Min 4
        expect(opt[:inventory][:ore]).to eq(1)
      end

      it "handles late game building properly" do
        blueprint = {:id=>1, :robots=>{:ore=>1, :clay=>4, :obsidian=>2, :geode=>0}, :inventory=>{:ore=>2, :clay=>1, :obsidian=>4, :geode=>0}, :minute=>16, :ore=>{:ore=>4}, :clay=>{:ore=>2}, :obsidian=>{:ore=>3, :clay=>14}, :geode=>{:ore=>2, :obsidian=>7}}
        expected = {:id=>1, :robots=>{:ore=>1, :clay=>4, :obsidian=>2, :geode=>1}, :inventory=>{:ore=>3, :clay=>13, :obsidian=>3, :geode=>0}, :minute=>19, :ore=>{:ore=>4}, :clay=>{:ore=>2}, :obsidian=>{:ore=>3, :clay=>14}, :geode=>{:ore=>2, :obsidian=>7}}
        options = ad.blueprint_options(blueprint)
        # ad.debug!
        expect(options).to include(expected)
      end


      it "spends multiple types of resources" do
        blueprint[:inventory][:ore] = 2
        blueprint[:inventory][:obsidian] = 7
        blueprint[:robots][:obsidian] = 1
        options = ad.blueprint_options(blueprint)
        expect(options.count).to eq(4)
        opt = options.find { |o| o[:robots][:geode] == 1}
        expect(opt).to_not be_nil
        expect(opt[:robots][:geode]).to eq(1)
        expect(opt[:inventory][:ore]).to eq(1)
        expect(opt[:inventory][:obsidian]).to eq(1)
      end

      it "doesn't mutate the original" do
        ad.blueprint_options(blueprint)
        expect(blueprint[:minute]).to eq(0)
      end

      it "accepts bounds and doesn't build beyond them" do
        blueprint[:robots] = {ore: 1, clay: 1, obsidian: 1, geode: 1}
        bounds = {ore: 1, clay: 1, obsidian: 1, geode: 1}
        options = ad.blueprint_options(blueprint, bounds)
        expect(options.count).to eq(1)
        expect(options.first[:robots]).to eq(blueprint[:robots])
      end

      # https://www.reddit.com/r/adventofcode/comments/zpy5rm/2022_day_19_what_are_your_insights_and/
      # Note that we can do a bit better:
      #   For any resource R that's not geode:
      #   if you already have X robots creating resource R,
      #     a current stock of Y for that resource, T minutes left,
      #     and no robot requires more than Z of resource R to build,
      #     and X * T+Y >= T * Z, then you never need to build another
      #     robot mining R anymore.

      # I credited the geodes the moment the geode bot was created
      # (ie a geode bot created with five minutes left was immediate +5 score),
      # which meant I no longer had to track the count of geode bots at all and
      # let me collapse some states together.
    end

    describe "#optimize_blueprint" do
      xit "returns the best blueprint" do
        #ad.debug!
        best = ad.optimize_blueprint(blueprint)
        expect(best[:inventory][:geode]).to eq(9)
      end

      xit "returns the best blueprint for id 2" do
        # ad.debug!
        best = ad.optimize_blueprint(blueprint2)
        expect(best[:inventory][:geode]).to eq(12)
      end

      context "part 2 longer" do
        let(:ad) { Advent::Ore.new(input, 32) }

        it "returns the best blueprint" do
          # ad.debug!
          best = ad.optimize_blueprint(blueprint)
          expect(best[:inventory][:geode]).to eq(56)
        end

        it "returns the best blueprint for id 2" do
          # ad.debug!
          best = ad.optimize_blueprint(blueprint2)
          expect(best[:inventory][:geode]).to eq(62)
        end
      end

    end

    describe "#quality_levels" do
      xit "returns the sum of all quality levels" do
        expect(ad.quality_levels).to eq(33)
      end
    end

    context "validation" do
    end
  end
end
