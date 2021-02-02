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

      it "defaults to zero if not present" do
        ad = Advent::Rpg.new("")
        expect(ad.boss[:hit]).to eq(0)
        expect(ad.boss[:damage]).to eq(0)
        expect(ad.boss[:armor]).to eq(0)
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

    describe "#magic_win?" do
      let(:player) {{
        hit: 10,
        damage: 0,
        armor: 0,
        mana: 250
      }}

      it "returns true if the player won" do
        spell = {mana: 53, dmg: 40}
        p = ad.simulate_step(player, spell)
        expect(ad.magic_win?(p)).to eq(true)
      end

      it "returns false if the boss won" do
        player[:hit] = 1
        p = ad.simulate_step(player, {})
        expect(ad.magic_win?(p)).to eq(false)
      end

      it "returns nil if the game is in progress" do
        expect(ad.magic_win?(player)).to be_nil
      end

      it "the boss wins if the player can't afford any spells" do
        player[:mana] = 52
        expect(ad.magic_win?(player)).to eq(false)
      end
    end

    describe "#magic_options" do
      it "returns a list of valid spells"
    end

    describe "#simulate_step" do
      let(:input) {
        <<~EOS
        Hit Points: 13
        Damage: 8
        EOS
      }
      let(:player) {{
        hit: 10,
        damage: 0,
        armor: 0,
        mana: 250
      }}

      it "starts the turn counter at 0" do
        expect(ad.turn).to eq(0)
      end

      it "advances the turn counter" do
        ad.simulate_step(player, {})
        expect(ad.turn).to eq(1)
      end

      it "ignores armor if it's magic" do
        ad.simulate_step(player, {mana: 53, dmg: 4})
        expect(ad.boss[:hit]).to eq(9)
      end

      it "the boss scores damage on the player" do
        expect(ad.simulate_step(player, {})).to eq({
          hit: 2,
          damage: 0,
          armor: 0,
          mana: 250,
        })
      end

      it "doesn't allow the boss a turn if the boss dies" do
        spell = {mana: 53, dmg: 40}
        expect(ad.simulate_step(player, spell)[:hit]).to eq(10)
      end

      it "applies magical healing" do
        spell = {mana: 73, dmg: 2, heal: 2}
        expect(ad.simulate_step(player, spell)[:hit]).to eq(10 - 8 + 2)
        expect(ad.boss[:hit]).to eq(13 - 2)
      end

      it "applies mana recharge over time" do
        spell = {mana: 229, duration: 5, mana_delta: 101}
        p = player
        p[:hit] = 100
        p = ad.simulate_step(p, spell)
        expect(p[:mana]).to eq(250 - 229 + 101)
        expect(ad.simulate_step(p, {})[:mana]).to eq(250 - 229 + 101 + 101 + 101)
      end

      it "applies damage over time" do
        spell = {mana: 173, duration: 6, dmg: 3}
        p = player
        p[:hit] = 100
        p = ad.simulate_step(p, spell)
        expect(ad.boss[:hit]).to eq(13 - 3)
        p = ad.simulate_step(p, {})
        expect(ad.boss[:hit]).to eq(13 - 3 - 3 - 3)
      end

      it "respects a spell's duration"
      it "applies armor over time"
      it "does at least one damage"
      it "prevents spells from being cast twice"
    end


    context "validation" do
    end
  end
end
