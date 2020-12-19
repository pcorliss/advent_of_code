require '../rules.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      0: 4 1 5
      1: 2 3 | 3 2
      2: 4 4 | 5 5
      3: 4 5 | 5 4
      4: "a"
      5: "b"

      ababbb
      bababa
      abbbab
      aaabbb
      aaaabbb
    EOS
  }

  describe Advent::Rules do
    let(:ad) { Advent::Rules.new(input) }

    describe "#new" do
      it "creates a collection of rules" do
        expect(ad.rules.count).to eq(6)
      end

      it "creates a collection of inputs" do
        expect(ad.inputs.count).to eq(5)
      end
    end

    describe "rule_parser" do
      it "breaks rules up into an array" do
        expect(ad.rule_parser).to be_a(Array)
        expect(ad.rule_parser.count).to eq(6)
      end

      it "indexes rules" do
        expect(ad.rule_parser[5]).to eq(["b"])
      end

      it "returns a list of sub rules" do
        expect(ad.rule_parser[0]).to eq([4,1,5])
      end

      it "handles conditional" do
        expect(ad.rule_parser[1]).to eq([2,3,'|',3,2])
      end
    end

    describe "#match?" do
      it "matches a single char" do
        expect(ad.match?([4], "a")).to be_truthy
        expect(ad.match?([5], "a")).to be_falsey
      end

      it "matches multiple chars" do
        expect(ad.match?([4,5], "ab")).to be_truthy
        expect(ad.match?([4,5], "ba")).to be_falsey
      end
      it "matches conditionals"
      it "matches nested conditionals"
      it "matches the whole string"
    end


    context "validation" do
    end
  end
end
