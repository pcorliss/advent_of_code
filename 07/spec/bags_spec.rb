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

  describe Advent::Bag do
    let(:ad) { Advent::Bag.new(input) }

    describe "#new" do
      it "loads a rules set" do
        expect(ad.rules.count).to eq(9)
      end

      it "creates rule objects" do
        expect(ad.rules.first).to be_a(Advent::BagReq)
      end
    end

    context "validation" do
    end
  end

  describe Advent::BagReq do
    let(:req) { Advent::BagReq.new(input.lines.first) }

    describe "#new" do
      it "parses the requirement" do
        expect(req.req).to eq({
          'light red' => Set.new(['bright white', 'muted yellow'])
        })
      end
    end
  end
end
