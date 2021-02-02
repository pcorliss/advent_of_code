require 'set'
require '../lib/grid.rb'

module Advent

  class Rpg
    attr_accessor :debug, :effects
    attr_reader :boss, :turn, :best_mana

    ATTR_MAP = {
      'Hit Points' => :hit,
      'Damage' => :damage,
      'Armor' => :armor,
    }
    def initialize(input)
      @debug = false
      @turn = 0
      @effects = []
      @boss = {
        hit: 0,
        damage: 0,
        armor: 0,
      }
      input.each_line do |line|
        line.chomp!
        attribute, val = line.split(': ')
        @boss[ATTR_MAP[attribute]] = val.to_i
      end
      @best_mana = nil
      @best_win = nil
    end

    def debug!
      @debug = true
    end

    def damage(player_stats)
      dmg = {
        boss: @boss[:damage] - player_stats[:armor],
        player: player_stats[:damage] - @boss[:armor],
      }
      dmg[:boss] = 1 if dmg[:boss] < 1
      dmg[:player] = 1 if dmg[:player] < 1

      dmg
    end

    def win?(player_stats)
      dmg = damage(player_stats)
      boss_rounds = player_stats[:hit] / dmg[:boss]
      boss_rounds += 1 if player_stats[:hit] % dmg[:boss] > 0
      player_rounds = @boss[:hit] / dmg[:player]
      player_rounds += 1 if @boss[:hit] % dmg[:player] > 0

      puts "Player: #{player_rounds}" if @debug
      puts "Boss: #{boss_rounds}" if @debug
      player_rounds <= boss_rounds
    end

    WEAPONS = [
      {cost: 8,  dmg: 4, arm: 0},
      {cost:10,  dmg: 5, arm: 0},
      {cost:25,  dmg: 6, arm: 0},
      {cost:40,  dmg: 7, arm: 0},
      {cost:74,  dmg: 8, arm: 0},
    ]

    ARMOR = [
      {cost: 13, dmg: 0, arm: 1},
      {cost: 31, dmg: 0, arm: 2},
      {cost: 53, dmg: 0, arm: 3},
      {cost: 75, dmg: 0, arm: 4},
      {cost:102, dmg: 0, arm: 5},
      {cost:  0, dmg: 0, arm: 0},
    ]

    RINGS = [
      {cost: 25, dmg: 1, arm: 0},
      {cost: 50, dmg: 2, arm: 0},
      {cost:100, dmg: 3, arm: 0},
      {cost: 20, dmg: 0, arm: 1},
      {cost: 40, dmg: 0, arm: 2},
      {cost: 80, dmg: 0, arm: 3},
      {cost:  0, dmg: 0, arm: 0},
      {cost:  0, dmg: 0, arm: 0},
    ]

    # Magic Missile costs 53 mana. It instantly does 4 damage.
    # Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
    # Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
    # Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.
    # Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.
    SPELLS = [
      {mana: 53, dmg: 4},
      {mana: 73, dmg: 2, heal: 2},
      {mana: 113, duration: 6, arm: 7},
      {mana: 173, duration: 6, dmg: 3},
      {mana: 229, duration: 5, mana_delta: 101},
    ]

    SPELL_MAP = {
      missile:  {mana: 53, dmg: 4},
      drain: {mana: 73, dmg: 2, heal: 2},
      shield: {mana: 113, duration: 6, arm: 7},
      poison: {mana: 173, duration: 6, dmg: 3},
      recharge: {mana: 229, duration: 5, mana_delta: 101},
    }
    def magic_options(mana, effects)
      effects ||= []
      SPELL_MAP.select do |name, spell|
        spell[:mana] <= mana &&
          !effects.any? {|e| e[:mana] == spell[:mana] && e[:duration] > 1 }
      end
    end

    def winning_combos(player, boss)
      wins = []
      magic_options(player[:mana], player[:effects]).each do |name, opt|
        # binding.pry if @debug && player[:history] && player[:history].first == :recharge && name == :shield
        new_player, new_boss = simulate_step(player, opt, boss)
        win = magic_win?(new_player, new_boss)
        new_player[:history] ||= []
        new_player[:history] << name
        if win
          wins << new_player
          puts "Found Winner: #{new_player} #{new_boss}" if @debug
        elsif win.nil?
          wins.concat winning_combos(new_player, new_boss)
        else
          # puts "Found Loser: #{new_player} #{new_boss}" if @debug
        end
      end
      wins
    end

    def mana(history)
      history.sum do |h|
        SPELL_MAP[h][:mana]
      end
    end

    # Need to add bail out step for run-time considerations
    # Maybe a breadth first approach as well
    def best_winning_combo(player, boss)
      magic_options(player[:mana], player[:effects]).each do |name, opt|
        # binding.pry if @debug && player[:history] && player[:history].first == :recharge && name == :shield
        new_player, new_boss = simulate_step(player, opt, boss)
        win = magic_win?(new_player, new_boss)
        new_player[:history] ||= []
        new_player[:history] << name
        if win
          # puts "Found Winner: #{new_player} #{new_boss}" if @debug
          mana_cost = mana(new_player[:history])
          if @best_mana.nil? || mana_cost < @best_mana
            puts "New Best: #{mana_cost} #{new_player[:history]}" if @debug
            @best_mana = mana_cost
            @best_win = new_player
          end
        elsif win.nil?
          return @best_win if @best_mana && mana(new_player[:history]) > @best_mana
          best_winning_combo(new_player, new_boss)
        else
          # puts "Found Loser: #{new_player} #{new_boss}" if @debug
        end
      end
      @best_win
    end

    require 'deep_clone'

    def simulate_step(player, spell, boss)
      raise "Test issue? Player is nil" if player.nil?
      raise "Test issue? Boss is nil" if boss.nil?

      @turn += 1

      player[:effects] ||= []
      player = DeepClone.clone player
      spell = spell.clone
      effects = player[:effects]
      boss = boss.clone

      player[:mana] -= spell[:mana] if spell[:mana]

      # Player Turn
      # Apply Spell Effects
      temp_armor = 0
      effects.each do |effect|
        next if effect[:duration] == 0
        effect[:duration] -= 1
        player[:mana] += effect[:mana_delta] if effect[:mana_delta]
        boss[:hit] -= effect[:dmg] if effect[:dmg]
        temp_armor = effect[:arm] if effect[:arm]
      end
      effects.delete_if {|e| e[:duration] <= 0}

      if spell[:duration]
        if effects.find {|e| e[:mana] == spell[:mana] }
          puts "WARN: spell #{spell} still in effect"
        else
          effects << spell
        end
        spell = {}
      end

      # Do Damage
      boss[:hit] -= spell[:dmg] if spell[:dmg]
      player[:hit] += spell[:heal] if spell[:heal]
      return [player, boss] if boss[:hit] <= 0

      # Boss Turn
      # Apply Spell Effects
      effects.each do |effect|
        next if effect[:duration] == 0
        effect[:duration] -= 1
        player[:mana] += effect[:mana_delta] if effect[:mana_delta]
        boss[:hit] -= effect[:dmg] if effect[:dmg]
        temp_armor = effect[:arm] if effect[:arm]
      end
      effects.delete_if {|e| e[:duration] <= 0}
      return [player,boss] if boss[:hit] <= 0

      # Do Damage
      pot_dmg = boss[:damage] - temp_armor
      pot_dmg = 1 if pot_dmg < 1
      player[:hit] -= pot_dmg

      [player, boss]
    end

    def magic_win?(player, boss)
      raise "Fail!!!" if player.nil?
      raise "Fail!!!" if boss.nil?
      # return false if player[:mana] < 53 # Min mana cost
      return nil if player[:hit] > 0 && boss[:hit] > 0
      return true if player[:hit] > 0
      return false if boss[:hit] > 0
      nil
    end

    def inventory
      inv = []
      WEAPONS.each do |w|
        ARMOR.each do |a|
          RINGS.combination(2).each do |r|
            equip = (r + [w] + [a]).flatten
            acc = {
              cost: 0,
              arm: 0,
              dmg: 0,
              inv: [],
            }
            equip.each do |item|
              acc[:cost] += item[:cost]
              acc[:arm] += item[:arm]
              acc[:dmg] += item[:dmg]
              acc[:inv] << item
              acc
            end
            inv << acc
          end
        end
      end
      inv
    end

    def lowest_cost_win(player)
      inventory.select do |inv|
        win?({
          hit: player,
          damage: inv[:dmg],
          armor: inv[:arm],
        })
      end.min_by do |inv|
        inv[:cost]
      end
    end

    def highest_cost_loss(player)
      inventory.reject do |inv|
        win?({
          hit: player,
          damage: inv[:dmg],
          armor: inv[:arm],
        })
      end.max_by do |inv|
        inv[:cost]
      end
    end
  end
end
