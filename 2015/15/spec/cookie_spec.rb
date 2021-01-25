require './cookie.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
    EOS
  }

  describe Advent::Cookie do
    let(:ad) { Advent::Cookie.new(input) }

    describe "#new" do
      it "inits an ingredients list" do
        expect(ad.ingredients['Butterscotch']).to eq(
          capacity: -1,
          durability: -2,
          flavor: 6,
          texture: 3,
          calories: 8,
        )
      end
    end

    describe "#score" do
      it "returns a score given an ingredient and quantity map" do
        ingredients = {
          'Butterscotch' => 44,
          'Cinnamon' => 56,
        }
        score = ad.score(ingredients)
        expect(score[:capacity]).to eq(68)
        expect(score[:durability]).to eq(80)
        expect(score[:flavor]).to eq(152)
        expect(score[:texture]).to eq(76)
        expect(score[:total]).to eq(62842880)
      end

      it "yields zero if any property is negative" do
        ingredients = {
          'Butterscotch' => 99,
          'Cinnamon' => 1,
        }
        score = ad.score(ingredients)
        expect(score[:capacity]).to eq(-97)
        expect(score[:total]).to eq(0)
      end

      it "takes a calories restriction as an optional argument" do
        ingredients = {
          'Butterscotch' => 40,
          'Cinnamon' => 60,
        }
        score = ad.score(ingredients, 500)
        expect(score[:total]).to eq(57600000)
      end

      it "returns 0, if it exceeds the restriction" do
        ingredients = {
          'Butterscotch' => 44,
          'Cinnamon' => 56,
        }
        score = ad.score(ingredients, 500)
        expect(score[:total]).to eq(0)
      end
    end

    describe "#optimal" do
      it "returns the optimal cookie recipie to achieve the maximum score" do
        expect(ad.optimal).to eq({
          'Butterscotch' => 44,
          'Cinnamon' => 56,
        })
      end

      it "handles more complex cases where incrementing from zero doesn't work" do
        input = <<~EOS
Frosting: capacity 4, durability -2, flavor 0, texture 0, calories 5
Candy: capacity 0, durability 5, flavor -1, texture 0, calories 8
Butterscotch: capacity -1, durability 0, flavor 5, texture 0, calories 6
Sugar: capacity 0, durability 0, flavor -2, texture 2, calories 1
        EOS
        ad = Advent::Cookie.new(input)
        opt = ad.optimal
        score = ad.score(opt)
        # puts "Opt: #{opt}"
        # puts "Score: #{score}"

        expect(score[:total]).to_not eq(0)
      end

    end

    describe "#optimal_with_calories" do
      it "handles a high calorie count" do
        expect(ad.optimal_with_calories(60000)).to eq(ad.optimal)
      end

      it "handles calorie restrictions" do
        expect(ad.optimal_with_calories(500)).to eq({
          'Butterscotch' => 40,
          'Cinnamon' => 60,
        })
      end

      it "handles more complex cases" do
        input = <<~EOS
Frosting: capacity 4, durability -2, flavor 0, texture 0, calories 5
Candy: capacity 0, durability 5, flavor -1, texture 0, calories 8
Butterscotch: capacity -1, durability 0, flavor 5, texture 0, calories 6
Sugar: capacity 0, durability 0, flavor -2, texture 2, calories 1
        EOS
        ad = Advent::Cookie.new(input)
        expect(ad.optimal_with_calories(60000)).to eq(ad.optimal)
      end
    end

    context "validation" do
    end
  end
end
