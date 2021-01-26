require './auntsue.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) { File.read './spec_input.txt' }

  describe Advent::AuntSue do
    let(:ad) { Advent::AuntSue.new(input) }

    describe "#new" do
      it "inits a list of properties" do
        expect(ad.aunts.count).to eq(500)
        expect(ad.aunts.first).to eq({
          goldfish: 9, cars: 0, samoyeds: 9
        })
      end
    end

    describe "#filter" do
      it "filters out aunts who don't have the same quantity for the property listed" do
        expect(ad.filter(goldfish: 9)).to include(1)
        expect(ad.filter(goldfish: 9)).to_not include(2)
      end

      it "doesn't filter out an aunt if we don't have that info" do
        expect(ad.filter(goldfish: 9)).to include(3)
      end

      it "handles multiple filters" do
        expect(ad.filter(cars: 0, trees: 8)).to include(1)
        expect(ad.filter(cars: 0, trees: 8)).to include(2)
        expect(ad.filter(cars: 0, trees: 8)).to_not include(3)
      end
    end

    describe "#range_filter" do
      it "cats readings indicates that there are greater than that many" do
        f = ad.range_filter(cats: 4)
        expect(f).to include(14, 15)
        expect(f).to_not include(9)
      end

      it "trees readings indicates that there are greater than that many" do
        f = ad.range_filter(trees: 5)
        expect(f).to include(2)
        expect(f).to_not include(3)
      end

      it "pomeranians readings indicate that there are fewer than that many" do
        f = ad.range_filter(pomeranians: 2)
        expect(f).to include(9)
        expect(f).to_not include(3)
      end

      it "goldfish readings indicate that there are fewer than that many" do
        f = ad.range_filter(goldfish: 9)
        expect(f).to include(2)
        expect(f).to_not include(1)
      end
    end


    context "validation" do
      it "returns the correct answer for filter" do
        expect(ad.filter(
          children: 3,
          cats: 7,
          samoyeds: 2,
          pomeranians: 3,
          akitas: 0,
          vizslas: 0,
          goldfish: 5,
          trees: 3,
          cars: 2,
          perfumes: 1,
        )).to contain_exactly(40)
      end

      it "returns the correct answer for range_filter" do
        expect(ad.range_filter(
          children: 3,
          cats: 7,
          samoyeds: 2,
          pomeranians: 3,
          akitas: 0,
          vizslas: 0,
          goldfish: 5,
          trees: 3,
          cars: 2,
          perfumes: 1,
        )).to contain_exactly(241)
      end
    end
  end
end
