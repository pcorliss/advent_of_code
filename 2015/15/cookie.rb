require 'set'
require '../lib/grid.rb'

module Advent

  class Cookie
    attr_accessor :debug
    attr_reader :ingredients

    ING_REGEX = /^(\w+): capacity ([-\d]+), durability ([-\d]+), flavor ([-\d]+), texture ([-\d]+), calories ([-\d]+)$/
    def initialize(input)
      @debug = false
      @ingredients = {}
      input.each_line do |line|
        line.chomp!
        # Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
        if line =~ ING_REGEX
          @ingredients[$1] = {
            capacity: $2.to_i,
            durability: $3.to_i,
            flavor: $4.to_i,
            texture: $5.to_i,
            calories: $6.to_i,
          }
        end
      end
      @properties = @ingredients.first.last.keys
    end

    def debug!
      @debug = true
    end

    def score(ings, max_calories = nil)
      return_score = {total: 1}

      @properties.each do |prop|
        total = ings.sum do |ing, quant|
          @ingredients[ing][prop] * quant
        end
        return_score[prop] = total
        if prop == :calories
          if max_calories && total > max_calories
            return_score[:total] = 0
          end
          next
        end
        total = 0 if total < 0
        return_score[:total] *= total 
      end

      return_score
    end

    def optimal
      initial_val = 1
      ing_list = @ingredients.keys
      opt = ing_list.inject({}) do |acc, ing|
        acc[ing] = initial_val
        acc
      end

      start_range = ing_list.length * initial_val + 1
      (start_range..100).each do |i|
        best_ing = ing_list.max_by do |ing|
          opt[ing] += 1
          s = score(opt)
          opt[ing] -= 1
          s[:total]
        end

        opt[best_ing] += 1
      end

      opt
    end

    def optimal_with_calories(max_calories)
      ing_list = @ingredients.keys

      best = (0..100).to_a.repeated_permutation(ing_list.length).max_by do |combo|
        combo.sum == 100 ? score(Hash[ing_list.zip(combo)], max_calories)[:total] : 0
      end

      Hash[ing_list.zip(best)]
    end
  end
end
