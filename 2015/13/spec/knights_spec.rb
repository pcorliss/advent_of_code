require './knights.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      Alice would gain 54 happiness units by sitting next to Bob.
      Alice would lose 79 happiness units by sitting next to Carol.
      Alice would lose 2 happiness units by sitting next to David.
      Bob would gain 83 happiness units by sitting next to Alice.
      Bob would lose 7 happiness units by sitting next to Carol.
      Bob would lose 63 happiness units by sitting next to David.
      Carol would lose 62 happiness units by sitting next to Alice.
      Carol would gain 60 happiness units by sitting next to Bob.
      Carol would gain 55 happiness units by sitting next to David.
      David would gain 46 happiness units by sitting next to Alice.
      David would lose 7 happiness units by sitting next to Bob.
      David would gain 41 happiness units by sitting next to Carol.
    EOS
  }

  describe Advent::Knights do
    let(:ad) { Advent::Knights.new(input) }

    describe "#new" do
      it "inits a happiness map" do
        expect(ad.happy_map['Alice']['Bob']).to eq(54)
        expect(ad.happy_map['Alice']['Carol']).to eq(-79)
      end

      it "inits a guests list" do
        expect(ad.guests).to contain_exactly(*%w(Alice Bob Carol David))
      end
    end

    describe "#sum_happiness" do
      it "returns the sum of happiness for a passed configuration" do
        expect(ad.sum_happiness(%w(Alice Bob Carol David))).to eq(330)
      end

      it "handles reversals and rotations and yields the same result" do
        expect(ad.sum_happiness(%w(Alice Bob Carol David).reverse)).to eq(330)
        expect(ad.sum_happiness(%w(Alice Bob Carol David).rotate)).to eq(330)
      end
    end

    describe "#optimal" do
      it "returns the optimal configuration" do
        expect(ad.optimal).to eq(%w(Alice Bob Carol David))
      end
    end

    context "validation" do
    end
  end
end
