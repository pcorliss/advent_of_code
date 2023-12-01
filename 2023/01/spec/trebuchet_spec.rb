require './trebuchet.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
    EOS
  }

  let(:input2) {
    <<~EOS
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
    EOS
  }

  describe Advent::Trebuchet do
    let(:ad) { Advent::Trebuchet.new(input) }
    let(:ad2) { Advent::Trebuchet.new(input2) }

    describe "#new" do
    end

    describe "#nums" do
      it "returns an array of numbers" do
        expect(ad.nums).to eq([12,38,15,77])
      end

      it "only grabs a single digit" do
        ad = Advent::Trebuchet.new("12abc2")
        expect(ad.nums).to eq([12])
      end

      it "extracts digits as strings" do
        expect(ad2.nums).to eq([29, 83, 13, 24, 42, 14, 76])
      end

      it "handles strings with overlapping numbers" do
        ad = Advent::Trebuchet.new("haseightwoeightwohas")
        expect(ad.nums).to eq([82])
      end
    end

    context "validation" do
      it "validates part1 examples" do
        expect(ad.sum).to eq(142)
      end

      it "validates part2 examples" do
        expect(ad2.sum).to eq(281)
      end
    end
  end
end
