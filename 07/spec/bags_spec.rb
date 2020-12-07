require '../bags.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      light red bags contain 1 bright white bag, 2 muted yellow bags.
      dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      bright white bags contain 1 shiny gold bag.
      muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      faded blue bags contain no other bags.
      dotted black bags contain no other bags.
    EOS
  }

  let(:input2) {
    <<~EOS
      shiny gold bags contain 2 dark red bags.
      dark red bags contain 2 dark orange bags.
      dark orange bags contain 2 dark yellow bags.
      dark yellow bags contain 2 dark green bags.
      dark green bags contain 2 dark blue bags.
      dark blue bags contain 2 dark violet bags.
      dark violet bags contain no other bags.
    EOS
  }

  describe Advent::Bag do
    let(:ad) { Advent::Bag.new(input) }

    describe "#new" do
      it "loads a rules set" do
        expect(ad.rules.count).to eq(9)
      end

      it "parses the requirement" do
        expect(ad.rules).to include({
          'light red' => Set.new(['bright white', 'muted yellow']),
        })
      end

      it "handles empty rule sets" do
        expect(ad.rules).to include({
          'dotted black' => Set.new,
        })
      end
    end

    describe "#required_bags" do
      let(:ad) { Advent::Bag.new(input2) }

      it "returns a count of how many bags are required internally with no nesting" do
        expect(ad.required_bags("dark violet")).to eq(0)
      end

      it "returns a count of how many bags are required with single nesting" do
        expect(ad.required_bags("dark blue")).to eq(2)
      end

      it "returns a count of how many bags are required with full nesting" do
        expect(ad.required_bags("shiny gold")).to eq(126)
      end
    end

    describe "#holding_bags" do
      it "returns an empty list of bags that can hold a color which can't be contained" do
        expect(ad.holding_bags("light red")).to be_empty
        expect(ad.holding_bags("dark orange")).to be_empty
      end

      it "returns multiple items when there are bags that can hold it" do
        expect(ad.holding_bags("muted yellow")).to contain_exactly("light red", "dark orange")
        expect(ad.holding_bags("bright white")).to contain_exactly("light red", "dark orange")
      end

      it "returns a recursive list of the bags that can hold it" do
        expect(ad.holding_bags("shiny gold")).to contain_exactly(
          "bright white",
          "muted yellow",
          "dark orange",
          "light red",
        )
      end
    end

    context "validation" do
      it "returns the proper amount for required internal bags" do
        expect(ad.required_bags("shiny gold")).to eq(32)
      end
    end
  end
end
