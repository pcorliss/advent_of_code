require 'set'

module Advent

  class Allergen

    attr_reader :foods, :ingredient_map, :allergen_map, :known_allergens
    def initialize(input)
      @foods = []
      @ingredient_map = {}
      @allergen_map = {}
      @known_allergens = {}

      input.each_line do |line|
        l = line.chomp
        l.gsub!(")", '')
        ingredients, allergens = l.split(' (contains ')
        ingredients_list = ingredients.split(" ")
        allergens_list = allergens.split(", ")
        @foods << [ingredients_list, allergens_list]
        ingredients_list.each do |ing|
          @ingredient_map[ing] ||= []
          @ingredient_map[ing] << [ingredients_list, allergens_list]
        end
        allergens_list.each do |all|
          @allergen_map[all] ||= []
          @allergen_map[all] << [ingredients_list, allergens_list]
        end
      end
    end

    def find_potential_allergen(allergen)
      common_ing = @allergen_map[allergen].map(&:first).inject(&:&)
      common_ing -= @known_allergens.values
      if common_ing.length == 1
        @known_allergens[allergen] = common_ing.first
      end
      common_ing
    end

    def id_allergens
      i = 0
      while @known_allergens.count < @allergen_map.count do
        @allergen_map.keys.each do |allergen|
          find_potential_allergen(allergen)
          # puts "f: #{f}"
        end
        puts "Iterating: #{i}"
        i += 1
        puts "Known: #{@known_allergens.keys}"
        puts "Unknown: #{@allergen_map.keys - @known_allergens.keys}"
        if i > 100
          raise "Breaking after 100 loops"
        end
      end
    end

    def safe_foods
      id_allergens
      @ingredient_map.keys - @known_allergens.values
    end
  end
end
