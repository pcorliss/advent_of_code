require 'set'
require '../lib/grid.rb'

module Advent

  class Rpg
    attr_accessor :debug
    attr_reader :boss

    ATTR_MAP = {
      'Hit Points' => :hit,
      'Damage' => :damage,
      'Armor' => :armor,
    }
    def initialize(input)
      @debug = false
      @boss = {}
      input.each_line do |line|
        line.chomp!
        attribute, val = line.split(': ')
        @boss[ATTR_MAP[attribute]] = val.to_i
      end
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
