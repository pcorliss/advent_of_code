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

    # describe "#gsub_rules!" do
    #   it "rewrites the rules in a first pass" do
    #     ad.gsub_rules!
    #     expect(ad.rule_parser[2]).to eq(["a", "a", "|", "b", "b"])
    #     expect(ad.rule_parser[3]).to eq(["a", "b", "|", "b", "a"])
    #   end
    #
    #   it "leaves base rules unchanged" do
    #     ad.gsub_rules!
    #     expect(ad.rule_parser[5]).to eq(["b"])
    #     expect(ad.rule_parser[4]).to eq(["a"])
    #   end
    # end
    
    # describe "#simplify_rules!" do
    #   it "doesn't touch rules that are already base case" do
    #     ad.simplify_rules!
    #     expect(ad.rule_parser[5]).to eq(["b"])
    #     expect(ad.rule_parser[4]).to eq(["a"])
    #   end
    #
    #   it "replaces elements of rules that contain a single level of depth" do
    #     ad.simplify_rules!
    #     expect(ad.rule_parser[2]).to eq(["a", "a", "|", "b", "b"])
    #     expect(ad.rule_parser[3]).to eq(["a", "b", "|", "b", "a"])
    #   end
    #
    #   it "replaces deeply nested elements" do
    #     ad.simplify_rules!
    #     ad.simplify_rules!
    #     expect(ad.rule_parser[1]).to eq(
    #       [
    #         ["a", "a", "|", "b", "b"],
    #         ["a", "b", "|", "b", "a"],
    #         "|",
    #         ["a", "b", "|", "b", "a"],
    #         ["a", "a", "|", "b", "b"]
    #       ]
    #     )
    #   end
    # end

    describe "parse_rule_to_regex" do
      it "ignores the base case" do
        expect(ad.parse_rule_to_regex("a")).to eq("a")
      end

      it "handles multiples" do
        expect(ad.parse_rule_to_regex("a b")).to eq("ab")
      end

      it "handles lookups" do
        expect(ad.parse_rule_to_regex("4 5")).to eq("ab")
      end

      it "handles conditionals" do
        expect(ad.parse_rule_to_regex("4 5 | 5 4")).to eq("(ab|ba)")
      end

      it "handles nesting" do
        expect(ad.parse_rule_to_regex("1")).to eq("(((aa|bb)(ab|ba)|(ab|ba)(aa|bb)))")
      end
    end

    describe "#rules_regex" do
      xit "constructs a rules regex" do
        expect(ad.rules_regex).to eq("^(a)()(b)$")
      # 0: 4 1 5
      # 1: 2 3 | 3 2
      # 2: 4 4 | 5 5
      # 3: 4 5 | 5 4
      # 4: "a"
      # 5: "b"
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

      it "matches conditionals" do
        expect(ad.match?([4, 5,'|', 5, 4], "ab")).to be_truthy
        expect(ad.match?([4, 5,'|', 5, 4], "ba")).to be_truthy
        expect(ad.match?([4, 5,'|', 5, 4], "ac")).to be_falsey
      end

      it "matches nested conditionals" do
        expect(ad.match?([4, 1, 5], "ababbb")).to be_truthy
        # expect(ad.match?([4, 1, 5], "aaabbb")).to be_falsey
      end

      it "matches the whole string" do
        expect(ad.match?([4], "aa")).to be_falsey
        expect(ad.match?([4, 1, 5], "aaaabbb")).to be_falsey
      end
    end


    context "validation" do
      {
        "ababbb" => true,
        "bababa" => false,
        "abbbab" => true,
        "aaabbb" => false,
        "aaaabbb" => false,
      }.each do |chars, expected|
        it "matches #{chars} as #{expected}" do
          expect(ad.match?([4,1,5], chars)).to eq(expected)
        end
      end

      it "correctly counts the number of matches" do
        expect(ad.match_count).to eq(2)
      end
    end
  end
end
