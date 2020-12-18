require '../homework.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      1 + 2 * 3 + 4 * 5 + 6
    EOS
  }

  describe Advent::Homework do
    let(:ad) { Advent::Homework.new(input) }

    describe "#new" do
      it "sets the expressions var" do
        expect(ad.expressions).to eq(["1 + 2 * 3 + 4 * 5 + 6"])
      end
    end

    describe "#parse" do
      it "converts strings into numbers" do
        expect(ad.parse("5")).to eq([5])
      end

      it "leaves operators alone" do
        expect(ad.parse("5 * 4")).to eq([5,'*',4])
      end

      it "converts parans into sub-arrays" do
        expect(ad.parse("1 + (2 * 3)")).to eq([1, '+', [2, '*', 3]])
      end

      it "handles nesting" do
        expect(ad.parse("1 + (2 * (3 * 3) * 4)")).to eq([1, '+', [2, '*', [3, '*', 3], '*', 4]])
      end

      context "precedence" do
        let(:ad) { Advent::Homework.new(input, '+') }

        xit "wraps terms when precedent is set" do
          expect(ad.parse("5 * 4")).to eq([5,'*',4])
          expect(ad.parse("5 + 4")).to eq([[5,'+',4]])
          expect(ad.parse("1 * 2 + 3")).to eq([1, '*', [2, '+', 3]])
        end

        xit "handles deep nesting" do
          expect(ad.parse("1 + (2 + (3 + 4))")).to eq([[1, '+', [[2, '+', [[3, '+', 4]]]]]])
        end
      end
    end

    describe "#evaluate" do
      it "handles single nums" do
        expect(ad.evaluate("5")).to eq(5)
      end

      it "handles two part expressions" do
        expect(ad.evaluate("5 * 4")).to eq(20)
      end

      it "handles nested expressions" do
        expect(ad.evaluate("1 + (2 * 3)")).to eq(7)
      end

      it "handles nesting" do
        expect(ad.evaluate("1 + (2 * (3 * 3) * 4)")).to eq(73)
      end
    end

    describe "#sum" do
      it "sums up the inputs" do
        expect(ad.sum).to eq(71)
      end
    end

    context "validation" do
      {
        "1 + 2 * 3 + 4 * 5 + 6" => 71,
        "1 + (2 * 3) + (4 * (5 + 6))" => 51,
        "2 * 3 + (4 * 5)" => 26,
        "5 + (8 * 3 + 9 + 3 * 4 * 3)" => 437,
        "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" => 12240,
        "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" => 13632,
      }.each do |expr, expected|
        it "evaluates #{expr} to #{expected}" do
          expect(ad.evaluate(expr)).to eq(expected)
        end
      end

      {
        "1 + 2 * 3 + 4 * 5 + 6" => 231,
        "1 + (2 * 3) + (4 * (5 + 6))" => 51,
        "2 * 3 + (4 * 5)" => 46,
        "5 + (8 * 3 + 9 + 3 * 4 * 3)" => 1445,
        "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" => 669060,
        "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" => 23340,
      }.each do |expr, expected|
        it "evaluates #{expr} to #{expected}" do
          ad = Advent::Homework.new(input, '+')
          expect(ad.evaluate(expr)).to eq(expected)
        end
      end
    end
  end
end
