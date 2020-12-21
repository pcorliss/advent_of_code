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

    context "validation" do
    end
  end
end
