require './password.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    111111-223451
    EOS
  }

  describe Advent::Password do
    let(:ad) { Advent::Password.new(input) }

    describe "#new" do
      it "sets the valid range" do
        expect(ad.range).to eq((111111..223451))
      end
    end

    describe "#valid_numbers" do
      it "excludes 5 digit numbers" do
        inp = "10000-20000"
        ad = Advent::Password.new(inp)
        expect(ad.valid_numbers).to be_empty
      end

      it "excludes 7 digit numbers" do
        inp = "1000000-1111111"
        ad = Advent::Password.new(inp)
        expect(ad.valid_numbers).to be_empty
      end

      it "respects the range given" do
        inp = "100000-140000"
        ad = Advent::Password.new(inp)
        expect(ad.valid_numbers.max <= 140000).to be_truthy
        expect(ad.valid_numbers.min >= 100000).to be_truthy
      end

      it "only includes numbers with two adjacent digits" do
        inp = "123455-123456"
        ad = Advent::Password.new(inp)
        expect(ad.valid_numbers).to contain_exactly(123455)
      end

      it "only includes numbers that increase" do
        inp = "123440-123444"
        ad = Advent::Password.new(inp)
        expect(ad.valid_numbers).to contain_exactly(123444)
      end
    end

    # It is a six-digit number.
    # The value is within the range given in your puzzle input.
    # Two adjacent digits are the same (like 22 in 122345).
    # Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
    # 111111 meets these criteria (double 11, never decreases).
    # 223450 does not meet these criteria (decreasing pair of digits 50).
    # 123789 does not meet these criteria (no double).
    context "validation" do

    end
  end
end
