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
  let(:boss) {{
    hit: 13,
    damage: 8,
    armor: 0,
  }}

  let(:spells) {{
    missile:  {mana: 53, dmg: 4},
    drain: {mana: 73, dmg: 2, heal: 2},
    shield: {mana: 113, duration: 6, arm: 7},
    poison: {mana: 173, duration: 6, dmg: 3},
    recharge: {mana: 229, duration: 5, mana_delta: 101},
  }}

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
      let(:boss) {{
        hit: 13,
        damage: 8,
        armor: 0,
      }}

      it "returns true if the player won" do
        spell = {mana: 53, dmg: 40}
        p, b = ad.simulate_step(player, spell, boss)
        expect(ad.magic_win?(p,b)).to eq(true)
      end

      it "returns false if the boss won" do
        player[:hit] = 1
        p, b = ad.simulate_step(player, {}, boss)
        expect(ad.magic_win?(p, b)).to eq(false)
      end

      it "returns nil if the game is in progress" do
        expect(ad.magic_win?(player, boss)).to be_nil
      end
    end

    describe "#magic_options" do
      it "returns a list of valid spells" do
        expect(ad.magic_options(500, [])).to eq(Advent::Rpg::SPELL_MAP)
      end

      it "filters out spells that are too expensive to cast" do
        expected = spells.slice(:missile, :drain)
        expect(ad.magic_options(73, [])).to contain_exactly(*expected)
      end

      it "filters out spells that will still be in effect" do
        effects = spells.slice(:poison, :shield, :recharge)
        effects[:recharge][:duration] = 1 # can be recast on the turn if expires
        effects[:poison][:duration] = 2
        effects[:shield][:duration] = 3
        expected = spells.slice(:missile, :drain, :recharge).map {|k, v| v[:mana]}
        expect(ad.magic_options(500, effects.values).map {|x, s| s[:mana]}).to contain_exactly(*expected)
      end
    end

    describe "#winning_combos" do
      let(:input) {
        <<~EOS
        Hit Points: 14
        Damage: 8
        EOS
      }
      let(:player) {{
        hit: 10,
        damage: 0,
        armor: 0,
        mana: 250
      }}

      it "returns all winning fight combos" do
        wins = ad.winning_combos(player, boss)
        expect(wins.count).to eq(139)
        expect(wins.first).to include(
          hit: 2,
          history: [:poison, :missile]
        )
      end

      it "returns a different scenario when the boss has more hit points" do
        # ad.debug!
        b = boss
        b[:hit] = 14
        wins = ad.winning_combos(player, boss)
        expect(wins.count).to eq(139)
        expect(wins.map {|w| w[:history]}).to include(
          [:recharge, :shield, :drain, :poison, :missile]
        )
      end
    end

    describe "#best_winning_combo" do
      let(:player) {{
        hit: 10,
        damage: 0,
        armor: 0,
        mana: 250
      }}
      it "returns the best mana cost" do
        p = player.clone
        b = boss.clone
        wins = ad.winning_combos(player, boss)
        best = wins.min_by do |w|
          ad.mana(w[:history])
        end
        ad.debug!
        best_combo = ad.best_winning_combo(p, b)
        puts best_combo
        expect(best_combo).to eq(best)
        expect(ad.best_mana).to eq(226)
      end
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
      let(:boss) {{
        hit: 13,
        damage: 8,
        armor: 0,
      }}

      it "starts the turn counter at 0" do
        expect(ad.turn).to eq(0)
      end

      it "advances the turn counter" do
        ad.simulate_step(player, {}, boss)
        expect(ad.turn).to eq(1)
      end

      it "ignores armor if it's magic" do
        _, b = ad.simulate_step(player, {mana: 53, dmg: 4}, boss)
        expect(b[:hit]).to eq(9)
      end

      it "the boss scores damage on the player" do
        expect(ad.simulate_step(player, {}, boss).first).to include({
          hit: 2,
        })
      end

      it "doesn't allow the boss a turn if the boss dies" do
        spell = {mana: 53, dmg: 40}
        expect(ad.simulate_step(player, spell, boss).first[:hit]).to eq(10)
      end

      it "applies magical healing" do
        spell = {mana: 73, dmg: 2, heal: 2}
        p, b = ad.simulate_step(player, spell, boss)
        expect(p[:hit]).to eq(10 - 8 + 2)
        expect(b[:hit]).to eq(13 - 2)
      end

      it "applies mana recharge over time" do
        spell = {mana: 229, duration: 5, mana_delta: 101}
        p = player
        p[:hit] = 100
        p, b = ad.simulate_step(p, spell, boss)
        expect(p[:mana]).to eq(250 - 229 + 101)
        expect(ad.simulate_step(p, {}, b).first[:mana]).to eq(250 - 229 + 101 + 101 + 101)
      end

      it "applies damage over time" do
        spell = {mana: 173, duration: 6, dmg: 3}
        p = player
        p[:hit] = 100
        p, b = ad.simulate_step(p, spell, boss)
        expect(b[:hit]).to eq(13 - 3)
        p, b = ad.simulate_step(p, {}, b)
        expect(b[:hit]).to eq(13 - 3 - 3 - 3)
      end

      it "respects a spell's duration" do
        spell = {mana: 229, duration: 5, mana_delta: 101}
        p = player
        p[:hit] = 100
        p, b = ad.simulate_step(p, spell, boss)
        p, b = ad.simulate_step(p, {}, b)
        p, b = ad.simulate_step(p, {}, b)
        expect(p[:mana]).to eq(250-229+101*5)
        p, b = ad.simulate_step(p, {}, b)
        expect(p[:mana]).to eq(250-229+101*5)
      end

      it "applies armor over time" do
        spell = {mana: 113, duration: 6, arm: 7}
        p, b = ad.simulate_step(player, spell, boss)
        expect(p[:hit]).to eq(10 - 1)
        expect(p[:armor]).to eq(0)
        p, b = ad.simulate_step(p, {}, b)
        expect(p[:hit]).to eq(10 - 1 - 1)
      end

      it "does at least one damage" do
        spell = {mana: 113, duration: 6, arm: 8}
        p, _ = ad.simulate_step(player, spell, boss)
        expect(p[:hit]).to eq(10 - 1)
      end

      it "prevents spells from being cast twice" do
        spell = {mana: 1, duration: 6, dmg: 3}
        p = player
        p[:hit] = 100
        p, b = ad.simulate_step(p, spell, boss)
        p, b = ad.simulate_step(p, spell, b)
        expect(b[:hit]).to eq(13 - 3 * 3)
      end
    end


    context "validation" do
      context "scenario 1" do
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
        let(:boss) {{
          hit: 13,
          damage: 8,
          armor: 0,
        }}

        it "simulates" do
          p = player
          b = boss
          p, b = ad.simulate_step(p, spells[:poison], b)
          expect(p[:hit]).to       eq(2)
          expect(b[:hit]).to eq(10)
          p, b = ad.simulate_step(p, spells[:missile], b)
          expect(p[:hit]).to       eq(2)
          expect(b[:hit]).to eq(0)
          expect(ad.magic_win?(p, b)).to eq(true)
        end
      end

      context "scenario 2" do
        let(:input) {
          <<~EOS
          Hit Points: 14
          Damage: 8
          EOS
        }
        let(:player) {{
          hit: 10,
          damage: 0,
          armor: 0,
          mana: 250
        }}
        let(:boss) {{
          hit: 14,
          damage: 8,
          armor: 0,
        }}

        it "simulates" do
          p = player
          b = boss
          p, b = ad.simulate_step(p, spells[:recharge], b)
          expect(p[:hit]).to       eq(2)
          expect(b[:hit]).to eq(14)
          expect(ad.magic_win?(p, b)).to be_nil
          p, b = ad.simulate_step(p, spells[:shield], b)
          expect(p[:hit]).to       eq(1)
          expect(b[:hit]).to eq(14)
          expect(ad.magic_win?(p, b)).to be_nil
          p, b = ad.simulate_step(p, spells[:drain], b)
          expect(p[:hit]).to       eq(2)
          expect(b[:hit]).to eq(12)
          expect(p[:mana]).to      eq(340)
          expect(ad.magic_win?(p, b)).to be_nil
          p, b = ad.simulate_step(p, spells[:poison], b)
          expect(p[:hit]).to       eq(1)
          expect(b[:hit]).to eq(9)
          expect(ad.magic_win?(p, b)).to be_nil
          p, b = ad.simulate_step(p, spells[:missile], b)
          expect(p[:hit]).to       eq(1)
          expect(b[:hit]).to eq(-1)
          expect(ad.magic_win?(p, b)).to eq(true)
        end
      end
    end
  end
end
