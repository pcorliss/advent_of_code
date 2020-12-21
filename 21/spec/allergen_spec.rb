require '../allergen.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
    trh fvjkl sbzzf mxmxvkd (contains dairy)
    sqjhc fvjkl (contains soy)
    sqjhc mxmxvkd sbzzf (contains fish)
    EOS
  }

  describe Advent::Allergen do
    let(:ad) { Advent::Allergen.new(input) }

    describe "#new" do
      it "creates a foods list" do
        expect(ad.foods.count).to eq(4)
        expect(ad.foods.first[0]).to eq(%w(mxmxvkd kfcds sqjhc nhms))
        expect(ad.foods.first[1]).to eq(%w(dairy fish))
      end

      it "creates an ingredient map that points to food listings" do
        expect(ad.ingredient_map["sqjhc"].count).to eq(3)
      end

      it "creates an allergen list that maps to ingredients" do
        expect(ad.allergen_map["soy"].count).to eq(1)
      end
    end

    describe "#find_potential_allergen" do
      it "looks for common ingredients amongst foods that contain the same allergen" do
        expect(ad.find_potential_allergen("fish")).to contain_exactly("mxmxvkd", "sqjhc")
      end

      it "adds allergens with only one known cause to the known_allergen_map" do
        expect(ad.find_potential_allergen("dairy")).to contain_exactly("mxmxvkd")
        expect(ad.known_allergens["dairy"]).to eq("mxmxvkd")
      end

      it "excludes foods that have previously been id'd" do
        ad.find_potential_allergen("dairy")
        expect(ad.find_potential_allergen("fish")).to contain_exactly("sqjhc")
      end
    end

    describe "#id_allergens" do
      it "iterates through the list of allergens until it finds all ingredients" do
        ad.id_allergens
        expect(ad.known_allergens["soy"]).to eq("fvjkl")
      end
    end

    describe "#safe_foods" do
      it "returns a list of foods which are not allergens" do
        expect(ad.safe_foods).to contain_exactly("kfcds", "nhms", "sbzzf", "trh")
      end
    end

    context "validation" do

      it "counts the number of recipies containing the safe ingredients" do
        count = ad.safe_foods.sum do |ing|
          ad.ingredient_map[ing].count
        end
        expect(count).to eq(5)
      end
    end
  end
end
