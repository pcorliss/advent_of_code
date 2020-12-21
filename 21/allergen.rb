require 'set'

module Advent

  class Allergen

    attr_reader :foods, :ingredient_map, :allergen_map
    def initialize(input)
      @foods = []
      @ingredient_map = {}
      @allergen_map = {}

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
  end
end
