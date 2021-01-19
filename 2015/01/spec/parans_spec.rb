require './parans.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    ))(((((
    EOS
  }

  describe Advent::Parans do
    let(:ad) { Advent::Parans.new(input) }

    describe "#new" do
      it "loads parans" do
        expect(ad.parans.count).to eq(7)
        expect(ad.parans.first).to eq(')')
        expect(ad.parans.last).to eq('(')
      end
    end

    describe "#floor" do
      it "returns the correct floor based on input" do
        expect(ad.floor).to eq(3)
      end
    end

    describe "#first_basement" do
      {
        ')' => 1,
        '()())' => 5,
      }.each do |inp, expected|
        it "returns #{expected} when given #{inp}" do
          ad = Advent::Parans.new(inp)
          expect(ad.first_basement).to eq(expected)
        end
      end
    end

    context "validation" do
      {
        '(())' => 0,
        '()()' => 0,
        '(((' => 3,
        '(()(()(' => 3,
        '))(((((' => 3,
        '())' => -1,
        '))(' => -1,
        ')))' => -3,
        ')())())' => -3,
      }.each do |inp, expected|
        it "returns #{expected} when given #{inp}" do
          ad = Advent::Parans.new(inp)
          expect(ad.floor).to eq(expected)
        end
      end
    end
  end
end
