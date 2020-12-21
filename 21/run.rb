#!/usr/bin/env ruby

require_relative 'allergen'

input = File.read('./input.txt')

ad = Advent::Allergen.new(input)
count = ad.safe_foods.sum do |ing|
  ad.ingredient_map[ing].count
end
puts "Count: #{count}"
ad.safe_foods
dangerous = ad.known_allergens.keys.sort.map do |allergen|
  ad.known_allergens[allergen]
end.join(",")
puts "Dangerous: #{dangerous}"
