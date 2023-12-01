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

  describe Advent::Trebuchet do
    let(:ad) { Advent::Trebuchet.new(input) }

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
    end

    context "validation" do
      it "validates part1 examples" do
        expect(ad.sum).to eq(142)
      end
    end
  end
end
