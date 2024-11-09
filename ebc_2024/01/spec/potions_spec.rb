require './potions.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input1) {
    <<~EOS
    ABBAC
    EOS
  }

  let(:input2) {
    <<~EOS
    AxBCDDCAxD
    EOS
  }

  let(:input3) {
    <<~EOS
    xBxAAABCDxCC
    EOS
  }

  describe Advent::Potions do
    let(:ad) { Advent::Potions.new(input1) }

    describe "#new" do
      it "instantiates a string of chars" do
        expect(ad).to be_a(Advent::Potions)
        expect(ad.bugs).to eq(["A", "B", "B", "A", "C"])
      end
    end

    describe "#potions" do
      it "returns the number of potions" do
        expect(ad.potions).to eq(5)
      end
    end

    context "validation" do
    end
  end

  describe Advent::Potions2 do
    let(:ad) { Advent::Potions2.new(input2) }


    describe "#new" do
      it "instantiates a string of chars" do
        expect(ad).to be_a(Advent::Potions2)
        expect(ad.bugs).to eq([["A", "x"], ["B", "C"], ["D", "D"], ["C", "A"], ["x", "D"]])
      end

      it "accepts group_size" do
        ad = Advent::Potions2.new(input3, 3)
        expect(ad.bugs).to eq([["x", "B", "x"], ["A", "A", "A"], ["B", "C", "D"], ["x", "C", "C"]])
      end
    end

    describe "#potions" do
      it "returns the number of potions" do
        expect(ad.potions).to eq(28)
      end

      it "returns the number of potions for larger group size" do
        ad = Advent::Potions2.new(input3, 3)
        expect(ad.potions).to eq(30)
      end
    end
  end
end
