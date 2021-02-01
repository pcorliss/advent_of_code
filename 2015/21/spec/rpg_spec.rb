require './rpg.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    Hit Points: 12
    Damage: 7
    Armor: 2
    EOS
  }

  describe Advent::Rpg do
    let(:ad) { Advent::Rpg.new(input) }

    describe "#new" do
      it "loads the boss' stats" do
        expect(ad.boss[:hit]).to eq(12)
        expect(ad.boss[:damage]).to eq(7)
        expect(ad.boss[:armor]).to eq(2)
      end
    end

    describe "#damage" do
      let(:player) {{
        hit: 1,
        damage: 4,
        armor: 5,
      }}

      it "returns the player damage minus boss armor" do
        expect(ad.damage(player)[:player]).to eq(2)
      end

      it "returns the boss damage minus player armor" do
        expect(ad.damage(player)[:boss]).to eq(2)
      end

      it "always returns at least one" do
        player[:armor] = 100
        ad.boss[:armor] = 100
        expect(ad.damage(player)[:boss]).to eq(1)
        expect(ad.damage(player)[:player]).to eq(1)
      end
    end

    describe "#win?" do
      let(:player) {{
        hit: 8,
        damage: 5,
        armor: 5,
      }}

      it "returns true if the player will win" do
        expect(ad.win?(player)).to be_truthy
      end

      it "returns false if the boss will win" do
        player[:hit] = 6
        expect(ad.win?(player)).to be_falsey
      end

      it "ensures the player goes first" do
        player[:hit] = 7
        expect(ad.win?(player)).to be_truthy
      end
    end

    describe "#inventory" do
      it "returns all valid inventory combinations" do
        expect(ad.inventory.count).to eq(840)
      end
    end

    describe "#lowest_cost_win" do
      it "returns the cheapest inventory setup that allows you to win" do
        # test input for the boss is so low that we only require a dagger
        expect(ad.lowest_cost_win(100)).to eq({
          :arm => 0,
          :cost => 8,
          :dmg => 4,
          :inv => [{:arm=>0, :cost=>0, :dmg=>0}, {:arm=>0, :cost=>0, :dmg=>0}, {:arm=>0, :cost=>8, :dmg=>4}, {:arm=>0, :cost=>0, :dmg=>0}],
        })
      end

      it "returns the cheapest inventory setup that allows you to win" do
        # test input for the boss is so low that we only require a dagger
        expect(ad.lowest_cost_win(2)).to eq({
          :arm => 6,
          :cost => 180,
          :dmg => 8,
          :inv => [{:arm=>0, :cost=>25, :dmg=>1}, {:arm=>2, :cost=>40, :dmg=>0}, {:arm=>0, :cost=>40, :dmg=>7}, {:arm=>4, :cost=>75, :dmg=>0}],
        })
      end
    end

    describe "#highest_cost_loss" do
      it "returns the highest inventory setup that allows you to lose" do
        expect(ad.highest_cost_loss(10)).to eq({
          :arm => 2,
          :cost => 148,
          :dmg => 7,
          :inv => [{:arm=>0, :cost=>100, :dmg=>3}, {:arm=>2, :cost=>40, :dmg=>0}, {:arm=>0, :cost=>8, :dmg=>4}, {:arm=>0, :cost=>0, :dmg=>0}],
        })
      end
    end

    context "validation" do
    end
  end
end
